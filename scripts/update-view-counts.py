#!/usr/bin/env python3
"""
Umami 浏览量数据更新脚本 (Python 版本)
查询 PostgreSQL 数据库，生成 view-counts.json 文件。

用法:
    python3 scripts/update-view-counts.py [--output PATH]

此脚本需要在部署服务器上运行（需要 docker 访问权限）。
它会从 umami-db 容器查询数据，并更新博客的公共数据文件。
"""

import subprocess
import json
import os
import sys
import tempfile
from pathlib import Path

# 配置
DB_CONTAINER = "umami-db"
DB_USER = "umami"
DB_NAME = "umami"
WEBSITE_ID = "cb8a8079-8971-4b42-9ac2-9092ba550af2"

# 获取项目根目录
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
DEFAULT_OUTPUT = PROJECT_DIR / "data" / "view-counts.json"


def run_psql_query(query: str) -> list[dict]:
    """在数据库容器中执行 SQL 查询并返回结果列表"""
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
            print(f"查询失败: {result.stderr.strip()}")
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
                    records.append({"x": path, "y": int(count)})
        
        return records
        
    except subprocess.TimeoutExpired:
        print("查询超时")
        return []
    except Exception as e:
        print(f"执行错误: {e}")
        return []


def check_tables() -> list[str]:
    """检查数据库中有哪些表"""
    query = "SELECT tablename FROM pg_tables WHERE schemaname = 'public';"
    return run_psql_query(query)


def query_pageviews() -> list[dict]:
    """查询页面浏览量数据"""
    
    # 查询 1: 尝试 website_event + website_data 结构 (Umami v3)
    print("尝试查询 website_event + website_data 结构...")
    query1 = f"""
    SELECT 
        d.value->>'path' as x,
        COUNT(*) as y
    FROM website_event e
    JOIN website_data d ON d.event_id = e.id
    WHERE e.website_id = '{WEBSITE_ID}'
      AND e.created_at >= '2024-01-01'
    GROUP BY d.value->>'path'
    ORDER BY y DESC;
    """
    
    results = run_psql_query(query1)
    if results:
        return results
    
    # 查询 2: 尝试直接从 website_event 获取 path
    print("尝试查询 website_event 直接获取 path...")
    query2 = f"""
    SELECT 
        e.website_path as x,
        COUNT(*) as y
    FROM website_event e
    WHERE e.website_id = '{WEBSITE_ID}'
      AND e.created_at >= '2024-01-01'
    GROUP BY e.website_path
    ORDER BY y DESC;
    """
    
    results = run_psql_query(query2)
    if results:
        return results
    
    # 查询 3: 尝试 website_pageview 表 (旧版本 Umami)
    print("尝试查询 website_pageview 表...")
    query3 = f"""
    SELECT 
        path as x,
        COUNT(*) as y
    FROM website_pageview
    WHERE website_id = '{WEBSITE_ID}'
      AND created_at >= '2024-01-01'
    GROUP BY path
    ORDER BY y DESC;
    """
    
    results = run_psql_query(query3)
    if results:
        return results
    
    # 查询 4: 列出所有表以帮助调试
    print("所有尝试均失败。数据库表结构:")
    tables = run_psql_query("SELECT tablename FROM pg_tables WHERE schemaname = 'public';")
    for t in tables:
        print(f"  - {t}")
    
    return []


def main():
    """主函数"""
    import argparse
    
    parser = argparse.ArgumentParser(description="更新 Umami 浏览量数据")
    parser.add_argument(
        "--output", "-o",
        default=str(DEFAULT_OUTPUT),
        help=f"输出 JSON 文件路径 (默认: {DEFAULT_OUTPUT})"
    )
    args = parser.parse_args()
    
    output_path = Path(args.output)
    
    print("=== Umami 浏览量数据更新 ===")
    print(f"输出文件: {output_path}")
    
    # 检查 Docker 容器是否运行
    cmd = ["docker", "ps", "--format", "{{.Names}}"]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
        if DB_CONTAINER not in result.stdout:
            print(f"错误: 数据库容器 {DB_CONTAINER} 未运行")
            print("请先启动服务: docker compose -f docker-compose.prod.yml up -d umami-db")
            sys.exit(1)
    except Exception as e:
        print(f"错误: 无法连接 Docker ({e})")
        sys.exit(1)
    
    # 查询数据
    print("正在查询数据库...")
    data = query_pageviews()
    
    if not data:
        print("警告: 未查询到任何数据")
        print("将使用空数据（所有浏览量为 0）")
        data = []
    
    # 确保输出目录存在
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    # 写入 JSON 文件
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"\n=== 完成 ===")
    print(f"已更新 {output_path}")
    print(f"包含 {len(data)} 条记录")
    
    # 提示
    print("\n提示: 数据已更新，刷新博客页面即可看到最新浏览量。")
    print("无需重建或重启容器（使用了 volume 挂载）。")


if __name__ == "__main__":
    main()
