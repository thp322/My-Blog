#!/bin/bash
# ============================================================
# Umami 浏览量数据更新脚本
# 查询 PostgreSQL 数据库，生成 view-counts.json 文件
# 过滤 localhost 访问，确保数据准确性
#
# 用法：
#   ./scripts/update-view-counts.sh
#
# 此脚本需要在部署服务器上运行（需要 docker 访问权限）
# 配合 cron 使用：*/5 * * * * /opt/my-blog/scripts.sh >> /opt/my-blog/logs/update-counts.log 2>&1
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

# 查询页面浏览量数据（过滤 localhost 访问）
echo "正在查询页面浏览量（排除 localhost）..."

# 使用 url_path 列（Umami v3+ 的列名），排除 localhost 访问
RESULT=$(docker exec "$DB_CONTAINER" \
    psql -U "$DB_USER" -d "$DB_NAME" -t -A -F "|" \
    -c "
SELECT url_path as x, COUNT(*) as y 
FROM website_event 
WHERE website_id = '$WEBSITE_ID' 
    AND created_at >= '2024-01-01'
    AND hostname != 'localhost'
GROUP BY url_path 
ORDER BY y DESC;" 2>/dev/null)

# 如果 url_path 列不存在，尝试 website_path 列（旧版本）
if [ -z "$RESULT" ]; then
    echo "尝试使用 website_path 列..."
    RESULT=$(docker exec "$DB_CONTAINER" \
        psql -U "$DB_USER" -d "$DB_NAME" -t -A -F "|" \
        -c "
SELECT website_path as x, COUNT(*) as y 
FROM website_event 
WHERE website_id = '$WEBSITE_ID' 
    AND created_at >= '2024-01-01'
    AND hostname != 'localhost'
GROUP BY website_path 
ORDER BY y DESC;" 2>/dev/null)
fi

# 如果仍然为空，尝试 website_data 表关联查询
if [ -z "$RESULT" ]; then
    echo "尝试 website_data 表关联查询..."
    RESULT=$(docker exec "$DB_CONTAINER" \
        psql -U "$DB_USER" -d "$DB_NAME" -t -A -F "|" \
        -c "
SELECT d.value->>'path' as x, COUNT(*) as y 
FROM website_event e
JOIN website_data d ON d.event_id = e.id
WHERE e.website_id = '$WEBSITE_ID' 
    AND e.created_at >= '2024-01-01'
GROUP BY d.value->>'path' 
ORDER BY y DESC;" 2>/dev/null)
fi

# 使用 awk 生成 JSON（与服务器上的 scripts.sh 保持一致）
echo "生成 JSON 文件..."
echo "$RESULT" | awk -F'|' '
BEGIN { printf "[" ; first=1 }
NF >= 2 && $1 != "" && $2 != "" {
    gsub(/^[ \t]+|[ \t]+$/, "", $1)
    gsub(/^[ \t]+|[ \t]+$/, "", $2)
    if (!first) printf ","
    printf "\n  {\"x\": \"%s\", \"y\": %d}", $1, $2
    first=0
}
END { printf "\n]\n" }
' > "$OUTPUT_FILE"

# 输出统计
ENTRY_COUNT=$(grep -c '"x":' "$OUTPUT_FILE" 2>/dev/null || echo "0")
echo ""
echo "=== 完成 ==="
echo "已更新 $OUTPUT_FILE"
echo "包含 $ENTRY_COUNT 条记录"
echo ""
echo "提示: 数据已更新，刷新博客页面即可看到最新浏览量。"
echo "无需重建或重启容器（使用了 volume 挂载）。"
