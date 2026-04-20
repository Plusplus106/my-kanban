#!/bin/bash

# ============================================================================
# Project Archiving Prompt Generator
# ============================================================================
# This script generates a complete AI prompt for archiving completed projects
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

# Main script
echo ""
print_color "$CYAN" "=========================================="
print_color "$CYAN" "📦 AI 專案歸檔提示詞產生器"
print_color "$CYAN" "=========================================="
echo ""

# Step 1: Select project
if [ -n "$1" ]; then
    selected_project="$1"
    projects=($(list_projects))
    if [[ " ${projects[*]} " =~ " $selected_project " ]]; then
        print_color "$GREEN" "✅ 已選擇專案: $selected_project"
        echo ""
    else
        print_color "$YELLOW" "❌ 指定的專案不存在: $selected_project"
        exit 1
    fi
else
    print_color "$CYAN" "📂 可用的專案："
    projects=($(list_projects))

    if [ ${#projects[@]} -eq 0 ]; then
        print_color "$YELLOW" "❌ 找不到專案（沒有專案包含 1-Specs/ 目錄）"
        echo ""
        read -p "是否需要協助產生其他階段的提示詞？ (y/n): " help_choice
        case $help_choice in
            [Yy]|[Yy][Ee][Ss])
                print_color "$GREEN" "✅ 跳回初始選擇..."
                exec "$SCRIPT_DIR/gen-prompt.sh"
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

    PS3="Select project (number): "
    select selected_project in "${projects[@]}"; do
        if [ -n "$selected_project" ]; then
             print_color "$GREEN" "✅ 已選擇專案: $selected_project"
             break
        else
             print_color "$YELLOW" "❌ Invalid selection. Please try again."
        fi
    done
    echo ""
fi

# Generate the complete AI prompt
print_color "$CYAN" "=========================================="
print_color "$CYAN" "📋 完整 AI 提示詞"
print_color "$CYAN" "=========================================="
echo ""

cat << EOF
請執行以下任務：

**⭐ 重要說明：專案歸檔是重要的資料整理工作**
- 本階段會將已完成的專案規格文件和計畫一起歸檔
- 需要確認所有計畫都已完成才能進行歸檔
- 歸檔後會刪除原始的 1-Specs/ 資料夾（包含 scripts/ 和 tests/）

---

**第一步：閱讀規則與確認歸檔條件**

請先閱讀以下文件以了解歸檔流程：

1. 讀取 \`$PROJECT_ROOT/templates/7-Done/DONE_RULES.md\`
2. 讀取 \`$PROJECT_ROOT/templates/8-Archived/ARCHIVED_RULES.md\` (or COMMON_CONVENTIONS.md)
3. 閱讀 \`$PROJECT_ROOT/promps/STAGE_05_DONE_TO_ARCHIVED.md\` 的完整內容

**第二步：掃描並列出可歸檔的專案**

1. 掃描 \`$PROJECT_ROOT/$selected_project/1-Specs/\` 中的所有專案資料夾
2. 列出所有專案及其基本資訊：
   - 專案資料夾名稱
   - 規格文件數量
   - 建立時間（從資料夾名稱提取）

3. 向用戶確認要歸檔哪個專案（或讓用戶輸入專案資料夾名稱）

**第三步：檢查專案完成狀態**

確認專案後，執行以下檢查：

1. 讀取專案規格文件，提取所有應該建立的計畫
2. 檢查 \`$PROJECT_ROOT/$selected_project/7-Done/\` (包含子資料夾) 中屬於此專案的已完成計畫
3. 檢查其他資料夾(2-Plans/3-Progressing/4-Testing/5-Re-testing/6-On-hold)確保沒有未完成的計畫
4. 逐一檢查 done 計畫是否包含 Testing 品質閘門證據（測試程式碼、測試指令、all green 輸出）
5. 使用「歸檔條件檢查清單」驗證是否可以歸檔

如果尚未準備好歸檔：
- 列出所有未完成的計畫
- 停下來等待處理未完成計畫

如果可以歸檔：
- 提供歸檔前的摘要
- 詢問用戶確認（回答「確認」以繼續）

**第四步：建立歸檔資料夾結構**

確認歸檔後：

1. 建立歸檔資料夾：
   \`\`\`
   $PROJECT_ROOT/$selected_project/8-Archived/[專案資料夾名稱]/
   ├── specs/
   └── 7-Done-2-Plans/
   \`\`\`

2. **只複製 .md 規格文件**到 specs/ 資料夾
   - ✅ 複製所有 .md 文件
   - ❌ 不複製 scripts/ 資料夾
   - ❌ 不複製 tests/ 資料夾

3. 移動所有屬於此專案的已完成計畫到 7-Done-2-Plans/ 資料夾 (⚠️ 請保持原有的子資料夾結構)
   - 若來源是 `no-spec` plan 文件，必須保留其共同父層資料夾後再移入

**第五步：建立專案歸檔摘要**

建立 \`[專案資料夾名稱]-summary.md\` 文件，包含：

1. 專案基本資訊（專案名稱、期間、歸檔時間）
2. 專案描述（專案目標、實際成果、專案簡述）
3. 專案統計（總計畫數、計畫分類統計、優先級統計、品質指標等）
4. 主要成果（列出 3-5 個主要成果）
5. 技術棧（使用的技術、框架、工具）
6. 檔案結構（規格文件列表、已完成計畫列表）
7. 學到的經驗（做得好的地方、可以改進的地方、未來建議）

請參考 STAGE_05 文件中的「摘要文件內容」範本。

**第六步：清理原始資料夾**

1. **完全刪除**原始專案資料夾：
   \`$PROJECT_ROOT/$selected_project/1-Specs/[專案資料夾名稱]/\`

   ⚠️ 包含 scripts/ 和 tests/ 資料夾都會被刪除

2. 確認 7-Done/ 中已無此專案的計畫

3. 使用「歸檔完成檢查清單」確認所有步驟都已完成

**第七步：提供歸檔完成報告**

提供詳細的歸檔報告，包含：
- 專案資訊
- 計畫統計
- 歸檔內容
- 清理完成狀態
- 歸檔位置
- 主要成果

⏸️ 完成後停下來，等待進一步指示。

**⚠️ 重要提醒：**
- 必須確認所有計畫都已完成才能歸檔
- 只歸檔 .md 規格文件，不歸檔 scripts/
- **🧹 全面來源清理審查（強制）：** 歸檔至 8-Archived 後，必須主動確認 1-Specs, 2-Plans, 3-Progressing, 4-Testing, 5-Re-testing, 6-On-hold, 7-Done 裡面皆無該批次任務或 plan 的殘留檔案、空資料夾。
- **🔍 驗證指令：** \`find kanban/{1-Specs,2-Plans,3-Progressing,4-Testing,5-Re-testing,6-On-hold,7-Done} -type f | grep -E "\$SPEC_ID|\$PLAN_ID"\`。若有任何輸出，表示清理不完整！
- **✅ Stage Exit Checkpoint（強制）：** 歸檔前必須確認所有 plan 文件的 checkbox 已全部勾選為 [✓]

---

現在請開始執行「第一步」。
EOF

echo ""
print_color "$CYAN" "=========================================="
echo ""
print_color "$YELLOW" "💡 提示：複製上面的提示詞（從「請執行以下任務」開始），貼到你的 AI 工具對話框中"
echo ""
print_color "$GREEN" "✅ 選擇的專案: $selected_project"
print_color "$GREEN" "✅ 執行規則位置: $PROJECT_ROOT/promps/STAGE_05_DONE_TO_ARCHIVED.md"
echo ""
