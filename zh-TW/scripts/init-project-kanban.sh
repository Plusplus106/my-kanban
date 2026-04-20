#!/bin/bash
# Kanban 專案初始化腳本
# 用途：快速為新專案建立完整的 Kanban 結構

# 使用方式: npm run init 或 yarn init-project-kanban
# 腳本會互動式詢問專案名稱和參考專案

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo ""
print_color "$CYAN" "=========================================="
print_color "$CYAN" "🚀 Kanban 專案初始化工具"
print_color "$CYAN" "=========================================="
echo ""

# Step 1: Get project name from user or command line argument
PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  print_color "$BLUE" "請輸入新專案名稱："
  read -p "> " PROJECT_NAME

  if [ -z "$PROJECT_NAME" ]; then
    print_color "$YELLOW" "❌ 錯誤：專案名稱不能為空"
    exit 1
  fi
fi

# Step 2: Check if project already exists
cd "$PROJECT_ROOT"

if [ -d "$PROJECT_NAME" ]; then
  print_color "$YELLOW" "❌ 錯誤：專案 '$PROJECT_NAME' 已存在"
  exit 1
fi

# Step 3: Check if templates directory exists
TEMPLATES_DIR="$PROJECT_ROOT/templates"

if [ ! -d "$TEMPLATES_DIR" ]; then
  print_color "$YELLOW" "❌ 錯誤：找不到 templates/ 資料夾"
  print_color "$YELLOW" "💡 提示：請確保 $TEMPLATES_DIR 存在且包含所有必要的模板和規則文件"
  exit 1
fi

echo ""
print_color "$CYAN" "=========================================="
print_color "$GREEN" "📋 開始建立專案: $PROJECT_NAME"
print_color "$CYAN" "=========================================="
echo ""
print_color "$BLUE" "📦 使用集中式模板：templates/"
echo ""

# Step 4: Create project folder structure (empty folders only)
print_color "$CYAN" "🏗️  建立資料夾結構..."
# Updated structure: Specs & Plans
mkdir -p "$PROJECT_NAME"/{1-Specs,2-Plans,3-Progressing,4-Testing,5-Re-testing,6-On-hold,7-Done,8-Archived}

# Step 5: No need to copy any files
# All templates and rules are centralized in templates/ directory
# AI tools will read them directly from there
print_color "$CYAN" "✅ 建立空資料夾結構（所有模板和規則統一從 templates/ 讀取）"

echo ""
print_color "$CYAN" "=========================================="
print_color "$GREEN" "✅ 專案 '$PROJECT_NAME' 建立完成！"
print_color "$CYAN" "=========================================="
echo ""
print_color "$BLUE" "📁 專案結構："
echo ""
echo "$PROJECT_NAME/"
echo "├── 1-Specs/              # 規格文件（空資料夾）"
echo "├── 2-Plans/              # 實作計畫（空資料夾）"
echo "├── 3-Progressing/        # 處理中計畫（空資料夾）"
echo "├── 4-Testing/            # 測試中計畫（空資料夾）"
echo "├── 5-Re-testing/         # 重新測試計畫（空資料夾）"
echo "├── 6-On-hold/            # 暫停計畫（空資料夾）"
echo "├── 7-Done/               # 已完成計畫（空資料夾）"
echo "└── 8-Archived/           # 已歸檔專案（空資料夾）"
echo ""
print_color "$YELLOW" "📌 重要："
echo "   所有模板和規則統一存放在 templates/ 目錄"
echo "   AI 工具會直接從 templates/ 讀取，無需複製"
echo ""
print_color "$BLUE" "🚀 下一步："
echo ""
echo "1. 使用 ./scripts/gen-idea-to-spec-prompt.sh 產生規格提示詞"
echo "2. 在 $PROJECT_NAME/1-Specs/ 中引導 AI 建立規格文件"
echo "3. 使用 ./scripts/gen-spec-to-plan-prompt.sh 產生實作計畫提示詞"
echo "4. 在 $PROJECT_NAME/2-Plans/ 中建立實作計畫"
echo ""
