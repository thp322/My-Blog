#!/bin/bash
# ============================================================
# Umami 浏览量数据更新脚本 (Shell 版本)
# 查询 PostgreSQL 数据库，生成 view-counts.json 文件
# 
# 用法：
#   ./scripts/update-view-counts.sh [--output PATH] [--keep-existing]
# 
# 此脚本需要在部署服务器上运行（需要 docker 访问权限）
# 它会从 umami-db 容器查询数据，并更新博客的公共数据文件
# ============================================================

set -euo pipefail

# 配置
DB_CONTAINER="umami-db"
DB_USER="umami"
DB_NAME="umami"
WEBSITE_ID="cb8a8079-8971-4b42-9ac2-9092ba550af2"

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
POSTS_DIR="$PROJECT_DIR/src/content/posts"
OUTPUT_FILE="$PROJECT_DIR/data/view-counts.json"

# 需要跟踪的基础页面
BASE_PATHS=("/" "/popular" "/search" "/tags")

# 解析参数
KEEP_EXISTING=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --output|-o)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --keep-existing)
            KEEP_EXISTING=true
            shift
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

echo "================================================"
echo "Umami 浏览量数据更新"
echo "输出文件: $OUTPUT_FILE"
echo "文章目录: $POSTS_DIR"

# 扫描所有文章
echo ""
echo "扫描文章..."
POST_SLUGS=()
if [ -d "$POSTS_DIR" ]; then
    for md_file in "$POSTS_DIR"/*.md; do
        if [ -f "$md_file" ]; then
            slug=$(basename "$md_file" .md)
            POST_SLUGS+=("$slug")
        fi
    done
fi
echo "检测到 ${#POST_SLUGS[@]} 篇文章"

# 构建预期路径列表
EXPECTED_PATHS=("${BASE_PATHS[@]}")
for slug in "${POST_SLUGS[@]}"; do
    EXPECTED_PATHS+=("/posts/$slug")
done
echo "需要跟踪 ${#EXPECTED_PATHS[@]} 个路径"

# 读取现有数据
EXISTING_DATA="{}"
if [ -f "$OUTPUT_FILE" ]; then
    EXISTING_DATA=$(cat "$OUTPUT_FILE" 2>/dev/null || echo "{}")
    echo "现有数据: $(echo "$EXISTING_DATA" | grep -c '"x":' 2>/dev/null || echo "0") 条记录"
fi

# 检查数据库容器是否运行
echo ""
echo "检查数据库容器..."
if ! docker ps --format '{{.Names}}' | grep -q "^${DB_CONTAINER}$"; then
    echo "⚠️  数据库容器 $DB_CONTAINER 未运行"
    echo "请先启动服务: docker compose -f docker-compose.prod.yml up -d umami-db"
    echo ""
    echo "将仅使用现有数据/默认值生成文件..."
    VIEW_COUNTS="{}"
else
    echo "数据库容器运行中"
    
    # 查询页面浏览量数据
    echo ""
    echo "查询页面浏览量..."
    
    # 方案 1: 使用 website_path 字段
    echo "尝试方案 1: website_event.website_path..."
    QUERY1="
SELECT 
  e.website_path as x,
  COUNT(*) as y
FROM website_event e
WHERE e.website_id = '$WEBSITE_ID'
  AND e.created_at >= '2024-01-01'
GROUP BY e.website_path
ORDER BY y DESC;
"
    
    RESULT=$(docker exec "$DB_CONTAINER" \
      psql -U "$DB_USER" -d "$DB_NAME" -t -A -F "|" \
      -c "$QUERY1" 2>/dev/null || echo "")
    
    # 如果方案 1 失败，尝试方案 2
    if [ -z "$RESULT" ]; then
        echo "方案 1 无结果，尝试方案 2..."
        
        QUERY2="
        SELECT 
          d.value->>'path' as x,
          COUNT(*) as y
        FROM website_event e
        JOIN website_data d ON d.event_id = e.id
        WHERE e.website_id = '$WEBSITE_ID'
          AND e.created_at >= '2024-01-01'
        GROUP BY d.value->>'path'
        ORDER BY y DESC;
        "
        
        RESULT=$(docker exec "$DB_CONTAINER" \
          psql -U "$DB_USER" -d "$DB_NAME" -t -A -F "|" \
          -c "$QUERY2" 2>/dev/null || echo "")
    fi
    
    # 如果仍然为空，尝试方案 3
    if [ -z "$RESULT" ]; then
        echo "方案 2 无结果，尝试方案 3..."
        
        QUERY3="
        SELECT 
          path as x,
          COUNT(*) as y
        FROM website_pageview
        WHERE website_id = '$WEBSITE_ID'
          AND created_at >= '2024-01-01'
        GROUP BY path
        ORDER BY y DESC;
        "
        
        RESULT=$(docker exec "$DB_CONTAINER" \
          psql -U "$DB_USER" -d "$DB_NAME" -t -A -F "|" \
          -c "$QUERY3" 2>/dev/null || echo "")
    fi
    
    if [ -n "$RESULT" ]; then
        echo "✅ 查询成功"
        VIEW_COUNTS=$(echo "$RESULT" | awk -F'|' '
        NF >= 2 && $1 != "" && $2 ~ /^[0-9]+$/ {
            gsub(/^[ \t]+|[ \t]+$/, "", $1)
            gsub(/^[ \t]+|[ \t]+$/, "", $2)
            printf "\"%s\":%d\n", $1, $2
        }' | paste -sd, -)
        if [ -n "$VIEW_COUNTS" ]; then
            VIEW_COUNTS="{$VIEW_COUNTS}"
        else
            VIEW_COUNTS="{}"
        fi
    else
        echo "⚠️  所有查询均失败"
        # 显示数据库表结构帮助调试
        echo "数据库表结构:"
        docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -t -A \
          -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public';" 2>/dev/null || echo "  (无法获取)"
        VIEW_COUNTS="{}"
    fi
fi

# 生成最终 JSON
echo ""
echo "生成 JSON 文件..."

# 构建完整数据
JSON_ARRAY="["
FIRST_ENTRY=true

for path in "${EXPECTED_PATHS[@]}"; do
    count=0
    
    # 查找浏览量
    if [ "$KEEP_EXISTING" = true ] && echo "$EXISTING_DATA" | grep -q "\"x\": \"$path\""; then
        # 保留现有数据
        count=$(echo "$EXISTING_DATA" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data:
    if item.get('x') == '$path':
        print(item.get('y', 0))
        break
" 2>/dev/null || echo "0")
    elif [ "$VIEW_COUNTS" != "{}" ]; then
        # 从查询结果获取
        count=$(echo "$VIEW_COUNTS" | python3 -c "
import sys, json
data = json.loads(sys.stdin.read().strip() or '{}')
print(data.get('$path', 0))
" 2>/dev/null || echo "0")
    elif echo "$EXISTING_DATA" | grep -q "\"x\": \"$path\""; then
        # 使用现有数据
        count=$(echo "$EXISTING_DATA" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data:
    if item.get('x') == '$path':
        print(item.get('y', 0))
        break
" 2>/dev/null || echo "0")
    fi
    
    # 确保 count 是数字
    if ! [[ "$count" =~ ^[0-9]+$ ]]; then
        count=0
    fi
    
    if [ "$FIRST_ENTRY" = true ]; then
        FIRST_ENTRY=false
    else
        JSON_ARRAY+=","
    fi
    JSON_ARRAY+="
  {\"x\": \"$path\", \"y\": $count}"
done

JSON_ARRAY+="
]"

# 写入文件
echo "$JSON_ARRAY" > "$OUTPUT_FILE"

# 统计
ENTRY_COUNT=$(grep -c '"x":' "$OUTPUT_FILE" 2>/dev/null || echo "0")
TOTAL_VIEWS=$(python3 -c "
import json
with open('$OUTPUT_FILE') as f:
    data = json.load(f)
print(sum(item['y'] for item in data))
" 2>/dev/null || echo "0")

echo ""
echo "================================================"
echo "✅ 完成"
echo "已更新: $OUTPUT_FILE"
echo "包含 $ENTRY_COUNT 条记录"
echo "总浏览量: $TOTAL_VIEWS"

echo ""
echo "💡 提示:"
echo "  - 数据已更新，刷新博客页面即可看到最新浏览量"
echo "  - 无需重建或重启容器（使用了 volume 挂载）"
echo "  - 如需设置定时任务，可使用: crontab -e"
echo "    0 */6 * * * cd $PROJECT_DIR && bash scripts/update-view-counts.sh"
