#!/usr/bin/env python3
"""
Umami 浏览量数据更新脚本
查询 PostgreSQL 数据库，生成 view-counts.json 文件。

用法:
    python3 scripts/update-view-counts.py [--output PATH] [--use-api] [--api-url URL] [--api-key KEY]

此脚本需要在部署服务器上运行（需要 docker 访问权限）。
它会从 umami-db 容器查询数据，并更新博客的公共数据文件。

支持两种模式:
1. 直接查询数据库 (默认)
2. 通过 Umami API 查询 (--use-api)
"""

import subprocess
import json
import os
import sys
import argparse
import urllib.request
import urllib.error
from pathlib import Path
from datetime import datetime

# 配置
DB_CONTAINER = "umami-db"
DB_USER = "umami"
DB_NAME = "umami"
WEBSITE_ID = "cb8a8079-8971-4b42-9ac2-9092ba550af2"

# 获取项目根目录
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
POSTS_DIR = PROJECT_DIR / "src" / "content" / "posts"
DEFAULT_OUTPUT = PROJECT_DIR / "data" / "view-counts.json"

# 需要跟踪的页面路径
BASE_PAGES = ["/", "/popular", "/search", "/tags"]


def get_all_post_slugs() -> list[str]:
    """扫描文章目录，获取所有文章的 slug 列表"""
    slugs = []
    if POSTS_DIR.exists():
        for md_file in sorted(POSTS_DIR.glob("*.md")):
            slugs.append(md_file.stem)
    return slugs


def get_expected_paths() -> list[str]:
    """获取所有应该跟踪的路径"""
    paths = list(BASE_PAGES)
    for slug in get_all_post_slugs():
        paths.append(f"/posts/{slug}")
    return paths


def fetch_from_docker_db() -> dict[str, int]:
    """通过 Docker 查询数据库获取浏览量"""
    
    def run_psql_query(query: str) -> list[tuple]:
        """在数据库容器中执行 SQL 查询并返回结果"""
        cmd = [
            "docker", "exec", DB_CONTAINER,
            "psql", "-U", DB_USER, "-d", DB_NAME,
            "-t", "-A", "-F", "|",
            "-c", query
        ]
        
        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=30
            )
            
            if result.returncode != 0:
                print(f"  查询失败: {result.stderr.strip()}")
                return []
            
            lines = result.stdout.strip().split("\n")
            records = []
            
            for line in lines:
                line = line.strip()
                if not line:
                    continue
                
                parts = line.split("|")
                if len(parts) >= 2:
                    path = parts[0].strip()
                    count = parts[1].strip()
                    
                    if path and count and count.isdigit():
                        records.append((path, int(count)))
            
            return records
            
        except subprocess.TimeoutExpired:
            print("  查询超时")
            return []
        except Exception as e:
            print(f"  执行错误: {e}")
            return []

    # 查询策略列表
    queries = [
        # 方案 1: website_event + website_data 结构 (Umami v3)
        """
        SELECT 
            d.value->>'path' as x,
            COUNT(*) as y
        FROM website_event e
        JOIN website_data d ON d.event_id = e.id
        WHERE e.website_id = '%s'
          AND e.created_at >= '2024-01-01'
        GROUP BY d.value->>'path'
        ORDER BY y DESC;
        """ % WEBSITE_ID,
        
        # 方案 2: website_event 直接获取 path
        """
        SELECT 
            e.website_path as x,
            COUNT(*) as y
        FROM website_event e
        WHERE e.website_id = '%s'
          AND e.created_at >= '2024-01-01'
        GROUP BY e.website_path
        ORDER BY y DESC;
        """ % WEBSITE_ID,
        
        # 方案 3: website_pageview 表 (旧版本 Umami)
        """
        SELECT 
            path as x,
            COUNT(*) as y
        FROM website_pageview
        WHERE website_id = '%s'
          AND created_at >= '2024-01-01'
        GROUP BY path
        ORDER BY y DESC;
        """ % WEBSITE_ID,
    ]
    
    print("  尝试从数据库查询浏览量...")
    
    for i, query in enumerate(queries, 1):
        print(f"  方案 {i}: 查询数据库...")
        results = run_psql_query(query)
        if results:
            print(f"  ✅ 方案 {i} 成功，获取 {len(results)} 条记录")
            return dict(results)
    
    # 列出所有表以帮助调试
    print("  所有方案均失败，检查数据库结构...")
    tables = run_psql_query("SELECT tablename FROM pg_tables WHERE schemaname = 'public';")
    if tables:
        print("  数据库表:")
        for table in tables:
            print(f"    - {table[0]}")
    
    return {}


def fetch_from_umami_api(api_url: str, api_key: str) -> dict[str, int]:
    """通过 Umami API 获取浏览量
    
    Umami API 端点: GET /api/websites/{id}/stats
    """
    print(f"  尝试从 Umami API 查询...")
    print(f"  API URL: {api_url}")
    
    try:
        # 获取统计数据
        stats_url = f"{api_url.rstrip('/')}/api/websites/{WEBSITE_ID}/stats"
        
        req = urllib.request.Request(
            stats_url,
            headers={
                'x-umami-api-key': api_key,
                'Accept': 'application/json'
            }
        )
        
        with urllib.request.urlopen(req, timeout=15) as response:
            data = json.loads(response.read().decode())
        
        # Umami API 返回的数据格式可能不同
        # stats 返回的是总体统计，不是按页面分组的
        print(f"  Stats API 返回: {json.dumps(data, indent=2)[:500]}...")
        
        # 尝试获取页面级别的统计
        # 使用 pageviews 端点
        pageviews_url = f"{api_url.rstrip('/')}/api/websites/{WEBSITE_ID}/pageviews"
        
        # 设置日期范围（最近 2 年）
        end_date = datetime.now().strftime("%Y-%m-%d")
        start_date = "2024-01-01"
        
        pageviews_req = urllib.request.Request(
            f"{pageviews_url}?startAt={start_date}&endAt={end_date}",
            headers={
                'x-umami-api-key': api_key,
                'Accept': 'application/json'
            }
        )
        
        with urllib.request.urlopen(pageviews_req, timeout=15) as response:
            pv_data = json.loads(response.read().decode())
        
        print(f"  Pageviews API 返回: {json.dumps(pv_data, indent=2)[:500]}...")
        
        # 处理 pageviews 数据
        # 返回格式: { data: [{path: "/xxx", count: 123}, ...] }
        result = {}
        
        if isinstance(pv_data, dict) and 'data' in pv_data:
            items = pv_data['data']
        elif isinstance(pv_data, list):
            items = pv_data
        else:
            items = []
        
        for item in items:
            if isinstance(item, dict):
                path = item.get('path', '')
                count = item.get('count', 0)
                if path and isinstance(count, (int, float)):
                    result[path] = int(count)
        
        print(f"  ✅ API 查询成功，获取 {len(result)} 条记录")
        return result
        
    except urllib.error.HTTPError as e:
        print(f"  HTTP 错误: {e.code} - {e.reason}")
        if e.code == 401:
            print("  API Key 无效或未配置")
    except urllib.error.URLError as e:
        print(f"  URL 错误: {e.reason}")
    except Exception as e:
        print(f"  API 查询失败: {e}")
    
    return {}


def check_docker_running() -> bool:
    """检查 Docker 是否运行以及数据库容器是否存在"""
    try:
        result = subprocess.run(
            ["docker", "ps", "--format", "{{.Names}}"],
            capture_output=True,
            text=True,
            timeout=10
        )
        if DB_CONTAINER not in result.stdout:
            print(f"  ⚠️  数据库容器 {DB_CONTAINER} 未运行")
            print(f"  请先启动服务: docker compose -f docker-compose.prod.yml up -d umami-db")
            return False
        return True
    except Exception as e:
        print(f"  ⚠️  无法连接 Docker ({e})")
        return False


def main():
    """主函数"""
    parser = argparse.ArgumentParser(description="更新 Umami 浏览量数据")
    parser.add_argument(
        "--output", "-o",
        default=str(DEFAULT_OUTPUT),
        help=f"输出 JSON 文件路径 (默认: {DEFAULT_OUTPUT})"
    )
    parser.add_argument(
        "--use-api",
        action="store_true",
        help="使用 Umami API 而非直接查询数据库"
    )
    parser.add_argument(
        "--api-url",
        default="https://umami.harperlog.cn",
        help="Umami 实例 URL (默认: https://umami.harperlog.cn)"
    )
    parser.add_argument(
        "--api-key",
        default=os.environ.get("UMAMI_API_KEY", ""),
        help="Umami API Key (也可通过环境变量 UMAMI_API_KEY 设置)"
    )
    parser.add_argument(
        "--keep-existing",
        action="store_true",
        help="保留现有数据，仅添加新文章（不更新浏览量）"
    )
    args = parser.parse_args()
    
    output_path = Path(args.output)
    
    print("=" * 50)
    print("Umami 浏览量数据更新")
    print(f"输出文件: {output_path}")
    print(f"文章目录: {POSTS_DIR}")
    
    # 获取所有应该跟踪的路径
    expected_paths = get_expected_paths()
    print(f"\n检测到 {len(get_all_post_slugs())} 篇文章")
    print(f"需要跟踪 {len(expected_paths)} 个路径")
    
    # 读取现有数据（用于保留已有数据）
    existing_data = {}
    if output_path.exists():
        try:
            with open(output_path, "r", encoding="utf-8") as f:
                existing_list = json.load(f)
                existing_data = {item["x"]: item["y"] for item in existing_list if "x" in item and "y" in item}
            print(f"现有数据: {len(existing_data)} 条记录")
        except Exception as e:
            print(f"⚠️  读取现有数据失败: {e}")
    
    # 获取浏览量数据
    view_counts = {}
    
    if args.use_api:
        # 使用 API 模式
        if not args.api_key:
            print("⚠️  未提供 API Key，使用空数据")
        else:
            view_counts = fetch_from_umami_api(args.api_url, args.api_key)
    else:
        # 使用数据库模式
        if check_docker_running():
            view_counts = fetch_from_docker_db()
        else:
            print("⚠️  Docker 不可用，尝试使用现有数据...")
    
    # 合并数据：确保所有预期的路径都有记录
    merged_data = []
    
    for path in expected_paths:
        if args.keep_existing and path in existing_data:
            # 保留现有数据
            merged_data.append({"x": path, "y": existing_data[path]})
        elif path in view_counts:
            # 使用从 umami 获取的新数据
            merged_data.append({"x": path, "y": view_counts[path]})
        elif path in existing_data:
            # 使用现有数据（可能是旧数据，但保留）
            merged_data.append({"x": path, "y": existing_data[path]})
        else:
            # 新文章或无数据，默认为 0
            merged_data.append({"x": path, "y": 0})
    
    # 如果查询到了额外的路径（不在预期列表中），也添加它们
    expected_set = set(expected_paths)
    for path, count in view_counts.items():
        if path not in expected_set:
            print(f"  ℹ️  发现额外路径: {path} (浏览量: {count})")
            merged_data.append({"x": path, "y": count})
    
    # 按浏览量降序排列，浏览量相同按路径排序
    merged_data.sort(key=lambda x: (-x["y"], x["x"]))
    
    # 确保输出目录存在
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    # 写入 JSON 文件
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(merged_data, f, ensure_ascii=False, indent=2)
    
    print(f"\n{'=' * 50}")
    print(f"✅ 完成")
    print(f"已更新: {output_path}")
    print(f"包含 {len(merged_data)} 条记录")
    
    # 显示数据摘要
    posts_with_views = [item for item in merged_data if item["y"] > 0 and item["x"].startswith("/posts/")]
    total_views = sum(item["y"] for item in merged_data)
    
    print(f"\n📊 数据摘要:")
    print(f"  总浏览量: {total_views:,}")
    print(f"  有浏览量的文章: {len(posts_with_views)} 篇")
    
    if posts_with_views:
        print("\n  热门文章 TOP 5:")
        for item in posts_with_views[:5]:
            print(f"    {item['x']}: {item['y']:,} reads")
    
    print(f"\n💡 提示:")
    print(f"  - 数据已更新，刷新博客页面即可看到最新浏览量")
    print(f"  - 无需重建或重启容器（使用了 volume 挂载）")
    print(f"  - 如需设置定时任务，可使用: crontab -e")
    print(f"    0 */6 * * * cd {PROJECT_DIR} && python3 scripts/update-view-counts.py")


if __name__ == "__main__":
    main()
