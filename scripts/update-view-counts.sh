#!/bin/bash
# ============================================================
# Umami 浏览量数据更新脚本
# 查询 PostgreSQL 数据库，生成 view-counts.json 文件
# 
# 用法：
#   ./scripts/update-view-counts.sh
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
OUTPUT_FILE="$PROJECT_DIR/data/view-counts.json"

echo "=== Umami 浏览量数据更新 ==="
echo "数据库容器: $DB_CONTAINER"
echo "输出文件: $OUTPUT_FILE"

# 检查数据库容器是否运行
if ! docker ps --format '{{.Names}}' | grep -q "^${DB_CONTAINER}$"; then
    echo "错误: 数据库容器 $DB_CONTAINER 未运行"
    exit 1
fi

# 查询页面浏览量数据
# Umami 的 website_event 表存储了页面浏览事件
# 需要关联 website_data 表获取 URL 路径
echo "正在查询页面浏览量..."

# 注意：Umami v3 的数据库结构可能不同
# 以下查询基于常见的 Umami schema
# 如果查询失败，请检查实际的表结构

QUERY="
SELECT 
  e.website_path as x,
  COUNT(*) as y
FROM website_event e
WHERE e.website_id = '$WEBSITE_ID'
  AND e.created_at >= '2024-01-01'
GROUP BY e.website_path
ORDER BY y DESC;
"

# 执行查询并将结果转换为 JSON
RESULT=$(docker exec "$DB_CONTAINER" \
  psql -U "$DB_USER" -d "$DB_NAME" -t -A \
  -c "$QUERY" 2>/dev/null || echo "")

# 如果查询结果为空，使用备选查询
if [ -z "$RESULT" ]; then
    echo "主查询无结果，尝试备选查询..."
    
    # 备选查询：使用 website_data 表
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
      psql -U "$DB_USER" -d "$DB_NAME" -t -A \
      -c "$QUERY2" 2>/dev/null || echo "")
fi

# 如果仍然为空，使用第三备选方案
if [ -z "$RESULT" ]; then
    echo "尝试第三备选查询..."
    
    # 查询所有表名以了解数据库结构
    TABLES=$(docker exec "$DB_CONTAINER" \
      psql -U "$DB_USER" -d "$DB_NAME" -t -A \
      -c "SELECT tablename FROM pg_tables WHERE schemaname = 'public';" 2>/dev/null || echo "")
    
    echo "数据库表:"
    echo "$TABLES"
    
    # 如果存在 website_pageview 表（某些 Umami 版本）
    if echo "$TABLES" | grep -q "website_pageview"; then
        echo "使用 website_pageview 表..."
        RESULT=$(docker exec "$DB_CONTAINER" \
          psql -U "$DB_USER" -d "$DB_NAME" -t -A \
          -c "SELECT path as x, COUNT(*) as y FROM website_pageview WHERE website_id = '$WEBSITE_ID' AND created_at >= '2024-01-01' GROUP BY path ORDER BY y DESC;" 2>/dev/null || echo "")
    fi
fi

# 处理结果并生成 JSON
echo "处理数据..."

# 初始化 JSON 数组
JSON_DATA="["
FIRST=true

# 如果有结果，处理每一行
if [ -n "$RESULT" ]; then
    echo "$RESULT" | while IFS='|' read -r path count; do
        # 跳过空行或无效数据
        if [ -z "$path" ] || [ -z "$count" ] || [ "$path" = "" ]; then
            continue
        fi
        
        # 去除可能的空白
        path=$(echo "$path" | xargs)
        count=$(echo "$count" | xargs)
        
        # 输出 JSON 行
        echo "  {\"x\": \"$path\", \"y\": $count}"
    done
fi

# 由于上面的循环在子 shell 中执行，我们需要重新处理
# 使用更可靠的方法生成 JSON
echo "生成 JSON 文件..."

# 创建临时文件
TEMP_FILE=$(mktemp)
echo "[" > "$TEMP_FILE"

if [ -n "$RESULT" ]; then
    FIRST_ENTRY=true
    echo "$RESULT" | while IFS='|' read -r path count; do
        path=$(echo "$path" | xargs)
        count=$(echo "$count" | xargs)
        
        if [ -n "$path" ] && [ -n "$count" ] && [ "$path" != "" ]; then
            if [ "$FIRST_ENTRY" = true ]; then
                FIRST_ENTRY=false
            else
                echo "," >> "$TEMP_FILE"
            fi
            echo "  {\"x\": \"$path\", \"y\": $count}" >> "$TEMP_FILE"
        fi
    done
fi

echo "]" >> "$TEMP_FILE"

# 移动到目标位置
cp "$TEMP_FILE" "$OUTPUT_FILE"
rm "$TEMP_FILE"

# 输出统计
ENTRY_COUNT=$(grep -c '"x":' "$OUTPUT_FILE" 2>/dev/null || echo "0")
echo ""
echo "=== 完成 ==="
echo "已更新 $OUTPUT_FILE"
echo "包含 $ENTRY_COUNT 条记录"
echo ""
echo "提示: 请重新构建并部署博客以应用更新："
echo "  docker compose -f docker-compose.prod.yml build blog"
echo "  docker compose -f docker-compose.prod.yml up -d blog"
