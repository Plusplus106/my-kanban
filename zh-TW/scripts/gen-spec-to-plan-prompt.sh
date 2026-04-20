#!/bin/bash

# ============================================================================
# Spec to Plan Prompt Generator
# ============================================================================
# This script generates a complete AI prompt for creating 2-Plans from specs
# ============================================================================

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function to list all projects
list_projects() {
    local projects=()
    for dir in "$PROJECT_ROOT"/*; do
        local dir_name="$(basename "$dir")"
        if [ -d "$dir/1-Specs" ] && [ "$dir_name" != "templates" ]; then
            projects+=("$dir_name")
        fi
    done
    echo "${projects[@]}"
}

# Function to list 1-Specs folders
list_specs_folders() {
    local project=$1
    local specs_dir="$PROJECT_ROOT/$project/1-Specs"

    if [ ! -d "$specs_dir" ]; then
        print_color "$YELLOW" "⚠️  Specs directory not found: $specs_dir"
        return 1
    fi

    # Use ls -d and handle empty results
    if ls -d "$specs_dir"/*/ >/dev/null 2>&1; then
        local folders=($(ls -d "$specs_dir"/*/ | xargs -n 1 basename))
        echo "${folders[@]}"
    else
        echo ""
    fi
}

# ============================================================================
# Main Script
# ============================================================================

echo ""
print_color "$CYAN" "=========================================="
print_color "$CYAN" "📋 從 Specs 建立 Plans 提示詞產生器"
print_color "$CYAN" "=========================================="
echo ""

# Step 1: Select project
if [ -n "$1" ]; then
    selected_project="$1"
    # Verify project exists
    if [ ! -d "$PROJECT_ROOT/$selected_project/1-Specs" ]; then
         print_color "$YELLOW" "❌ Project not found or invalid: $selected_project"
         exit 1
    fi
    print_color "$GREEN" "✅ Selected project: $selected_project"
else
    # Use select menu for project selection
    print_color "$GREEN" "📂 Available Projects:"
    projects=($(list_projects))
    
    if [ ${#projects[@]} -eq 0 ]; then
        print_color "$YELLOW" "⚠️  No projects with 1-Specs found."
        exit 1
    fi
    
    PS3="Select project (number): "
    select project_choice in "${projects[@]}"; do
        if [ -n "$project_choice" ]; then
            selected_project="$project_choice"
            print_color "$GREEN" "✅ 已選擇專案: $selected_project"
            break
        else
            print_color "$YELLOW" "❌ Invalid selection. Please try again."
        fi
    done
fi
echo ""

# Step 2: Select 1-Specs folder
print_color "$CYAN" "📁 1-Specs/ 中可用的規格資料夾："
folders=($(list_specs_folders "$selected_project"))

if [ ${#folders[@]} -eq 0 ]; then
    print_color "$YELLOW" "⚠️  1-Specs/ 目錄為空，沒有可用的規格資料夾。"
    echo ""
    read -p "是否需要協助產生規格文件的提示詞？ (y/n): " help_choice
    case $help_choice in
        [Yy]|[Yy][Ee][Ss])
            print_color "$GREEN" "✅ 跳回初始選擇..."
            exec "$SCRIPT_DIR/gen-idea-to-spec-prompt.sh"
            ;;
        [Nn]|[Nn][Oo])
            print_color "$GREEN" "謝謝您的使用，再見！"
            exit 0
            ;;
        *)
            print_color "$YELLOW" "❌ 無效的選擇"
            exit 1
            ;;
    esac
fi

PS3="Select specs folder (number): "
select selected_folder in "${folders[@]}"; do
    if [ -n "$selected_folder" ]; then
        # Verify 1-Specs folder exists
        specs_folder_path="$PROJECT_ROOT/$selected_project/1-Specs/$selected_folder"
        if [ ! -d "$specs_folder_path" ]; then
            print_color "$YELLOW" "❌ 找不到規格資料夾: $specs_folder_path"
            exit 1
        fi
        print_color "$GREEN" "✅ 已選擇規格資料夾: $selected_folder"
        break
    else
         print_color "$YELLOW" "❌ Invalid selection. Please try again."
    fi
done
echo ""

# Check if there are any .md files in the 1-Specs folder
md_file_count=$(find "$specs_folder_path" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')

if [ "$md_file_count" -eq 0 ]; then
    echo ""
    print_color "$YELLOW" "=========================================="
    print_color "$YELLOW" "⚠️  規格資料夾中沒有任何文件"
    print_color "$YELLOW" "=========================================="
    echo ""
    print_color "$YELLOW" "資料夾: $selected_folder"
    print_color "$YELLOW" "路徑: $specs_folder_path"
    echo ""
    print_color "$YELLOW" "📝 此規格資料夾目前是空的,沒有任何 .md 規劃文件。"
    print_color "$YELLOW" "   無法產生 Plans。"
    echo ""
    print_color "$CYAN" "💡 建議的下一步："
    echo "   1. 使用 gen-idea-to-spec-prompt.sh 產生規格文件"
    echo "   2. 確保文件中詳細描述功能需求、技術架構等資訊"
    echo "   3. 再次執行此腳本來產生 Plans"
    echo ""
    exit 1
fi

print_color "$GREEN" "✅ 找到 $md_file_count 個規格文件"
echo ""

# Generate the complete AI prompt
print_color "$CYAN" "=========================================="
print_color "$CYAN" "📋 完整 AI 提示詞"
print_color "$CYAN" "=========================================="
echo ""

cat << EOF
請執行以下任務：

**第一步：閱讀規則文件**
請閱讀 \`$PROJECT_ROOT/templates/2-Plans/PLANS_RULES.md\` 的完整內容，了解計畫拆分的流程和規範。

**第二步：閱讀規格文件**
請閱讀 \`$specs_folder_path\` 資料夾中的所有規格 (Specs) 文件（.md 檔案），了解專案的整體目標和需求。

重點關注：
- 專案的核心功能和需求
- 技術架構和設計決策
- 檔案中標註的依賴關係（如 [001]、[002] 等編號代表執行順序）
- 需要建立或修改的檔案

**第三步：閱讀計畫模板**
請閱讀 \`$PROJECT_ROOT/templates/2-Plans/.plan-template.md\`,了解計畫卡片的標準格式。

**第四步：拆分計畫**
依照 PLANS_RULES 的規則，執行計畫拆分：

1. **拆分原則**
   - 將專案 Spec 拆分為獨立的、可執行的實作計畫 (Plans)
   - 每個計畫應該是一個明確的工作單元（建議開發時間：4-8 小時）
   - 盡可能將計畫拆分為**互不依賴**的獨立計畫，以支援並行開發
   - 如果計畫過於複雜，請拆分為主計畫和子計畫

2. **優先級評估**（基於阻塞性和重要性，而非技術複雜度）
   - **🔴 緊急優先級** - 會阻塞其他計畫的基礎設施計畫（如資料模型定義、介面定義、測試環境配置）
   - **🟠 高優先級** - 核心功能或重要計畫
   - **🟡 中優先級** - 重要但不緊急的計畫
   - **🟢 低優先級** - 支援性計畫（如文件撰寫、代碼清理）
   - **⚪ 建議執行** - 優化性質的計畫

   **類別優先級限制：**
   - bug 類別：只能是 urgent 或 high
   - test 類別：必須是 mid 或以下（mid/low）
   - docs 類別：固定在 low
   - feature/refactor 類別：可使用 suggest

3. **評估資訊**
   - 類別: feature / bug / refactor / test / docs
   - 優先級: urgent / high / mid / low / suggest
   - 預估複雜度: 高 / 中 / 低
   - 是否可並行執行: 是 / 否（並說明原因）

**第五步：建立計畫卡片**

1. 使用檔案命名規範：
   - **一般計畫:** \`[YYYY-MM-DD]-[spec-xxxxx]-[數字]-[優先級]-[plan-yyyyy]-[類別]-簡短描述.md\`
   - **Phase 計畫:** \`[YYYY-MM-DD]-[spec-xxxxx]-phase-[N]-[數字]-[優先級]-[plan-yyyyy]-[類別]-簡短描述.md\`
     - 若計畫有分階段執行（Phase 1, Phase 2...），務必使用此格式以便排序
   - **無 Spec 計畫:** \`[YYYY-MM-DD]-[no-spec]-[數字]-[優先級]-[plan-xxxxx]-[類別]-簡短描述.md\`
   
   **參數說明:**
   - \`[YYYY-MM-DD]\`: 計畫建立日期
   - \`[spec-xxxxx]\`: 從規格文件提取的 Spec 編號
   - \`phase-[N]\`: 階段編號（如 phase-1, phase-2），可選
   - \`[數字]\`: 優先級對應數字 (1-urgent, 2-high, 3-mid, 4-low, 5-suggest)
   - \`[優先級]\`: urgent, high, mid, low, suggest
   - \`[plan-yyyyy]\`: 隨機生成的 5 碼計畫編號
   - \`[類別]\`: feature, bug, refactor, test, docs

2. 準備計畫資料夾：
   - 在 \`$PROJECT_ROOT/$selected_project/2-Plans/\` 下建立與規格資料夾同名的子資料夾
   - 例如：若規格資料夾為 \`1-Specs/2025-12-01-[spec-Ax4m2]-feature-login/\`
   - 則建立 \`2-Plans/2025-12-01-[spec-Ax4m2]-feature-login/\`
   - 無論本次需建立 1 個或多個 plan 文件，都必須先確認共同父層資料夾已建立後，才可開始建立個別 plan 文件

3. 使用計畫模板格式，必須填寫的欄位：
   - 計畫名稱
   - 建立時間（填入實際當前時間，格式: YYYY-MM-DD HH:mm）
   - 狀態: 待辦 (To Do)
   - 類別
   - 優先級
   - 預估複雜度
   - 是否可並行執行（並說明原因）
   - 參考文件（列出相關規格文件的完整路徑）
   - 計畫描述（詳細說明要做什麼、需要建立/修改的檔案、預期輸入輸出）
   - 是否有子計畫
   - 子計畫列表（如果有）
   - 依賴關係（包含：依賴、開發階段、執行階段、外部依賴、可並行開發）

4. 將所有計畫卡片放到剛剛建立的 \`2-Plans/[子資料夾]/\` 中
   - 不可省略父層資料夾，也不可直接放在 \`2-Plans/\` 根目錄

**第六步：建立計畫拆分摘要文件**

1. 在完成所有計畫卡片建立後，請建立一份完整的計畫拆分摘要文件
2. 檔案名稱：\`PLAN_BREAKDOWN_\$(date +%Y_%m_%d).md\`（使用當天日期，底線分隔）
3. 檔案位置：\`$specs_folder_path/\`（與規格文件放在同一層）
4. 文件內容必須包含：
   - **文件版本**（從 1.0 開始）
   - **建立日期**（填入實際日期，格式：YYYY-MM-DD）
   - **Generated by**（標註使用的 AI 工具名稱）
   - **專案名稱**（$selected_project）
   - **專案目標**（從規格文件中提取）
   - 📋 執行摘要
   - 📊 計畫統計（總數、按優先級分類、按類別分類、並行執行能力）
   - 📁 完整計畫清單（按優先級分類，包含簡短描述）
   - 🔄 計畫依賴關係與執行階段規劃
   - 📈 執行時間估算（可選）
   - 🎯 成功指標
   - 📝 注意事項
   - 📚 參考文件清單

**第七步：提供摘要**

完成後，請提供以下資訊：
1. 列出所有建立的計畫檔案名稱
2. 說明計畫之間的依賴關係和並行執行計畫
3. 提供統計資訊（各優先級計畫數量、可並行執行的計畫數量）
4. 確認已建立計畫拆分摘要文件的位置
5. 停下動作，等待確認

**⚠️ 重要提醒：**
- 此階段只負責建立計畫卡片，不要開始實作
- 不要在 2-Plans 階段填寫「負責的 AI 工具」欄位
- 計畫描述要足夠詳細，讓其他 AI 工具可以直接根據描述開始開發
- 盡可能最大化計畫的並行執行能力
- 優先級評估應基於阻塞性和重要性，而非技術複雜度
- 使用正確的檔案命名格式（全小寫）
- 在「參考文件」欄位中列出完整的文件路徑

---

現在請開始執行任務。
EOF

echo ""
print_color "$CYAN" "=========================================="
echo ""
print_color "$YELLOW" "💡 提示：複製上面的提示詞（從「請執行以下任務」開始），貼到你的 AI 工具對話框中"
echo ""
print_color "$GREEN" "✅ 規格資料夾位置: $specs_folder_path"
print_color "$GREEN" "✅ 執行規則位置: $PROJECT_ROOT/templates/2-Plans/PLANS_RULES.md"
print_color "$GREEN" "✅ 計畫模板位置: $PROJECT_ROOT/templates/2-Plans/.plan-template.md"
print_color "$GREEN" "✅ 計畫輸出位置: $PROJECT_ROOT/$selected_project/2-Plans/"
echo ""
