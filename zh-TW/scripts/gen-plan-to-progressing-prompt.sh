#!/bin/bash

# ============================================================================
# Plan Execution Prompt Generator
# ============================================================================
# This script generates a complete AI prompt for executing a todo plan
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

# Function to list plans in 2-Plans folder (recursive)
list_plans() {
    local project=$1
    local plans_dir="$PROJECT_ROOT/$project/2-Plans"

    if [ ! -d "$plans_dir" ]; then
        print_color "$YELLOW" "⚠️  Plans directory not found: $plans_dir"
        return 1
    fi

    # Find all .md files, get relative path from plans_dir
    local plans=()
    while IFS= read -r file; do
        plans+=("$file")
    done < <(cd "$plans_dir" && find . -type f -name "*.md" ! -name ".*" | sed 's|^\./||' | sort)

    if [ ${#plans[@]} -eq 0 ]; then
        print_color "$YELLOW" "⚠️  No plans found in $plans_dir"
        return 1
    fi

    echo "${plans[@]}"
}

# Main script
echo ""
print_color "$CYAN" "=========================================="
print_color "$CYAN" "🤖 AI 計畫執行提示詞產生器"
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
        print_color "$YELLOW" "❌ 找不到專案"
        exit 1
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

# Step 2: Select plan
print_color "$CYAN" "📋 2-Plans/ 中可用的計畫："
plans=($(list_plans "$selected_project"))

if [ ${#plans[@]} -eq 0 ]; then
    print_color "$YELLOW" "⚠️  2-Plans/ 目錄為空，沒有可用的計畫。"
    echo ""
    read -p "是否需要協助產生計畫？ (y/n): " help_choice
    case $help_choice in
        [Yy]|[Yy][Ee][Ss])
            print_color "$GREEN" "✅ 跳回初始選擇..."
            exec "$SCRIPT_DIR/gen-spec-to-plan-prompt.sh"
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

PS3="Select plan (number): "
select plan_input in "${plans[@]}"; do
    if [ -n "$plan_input" ]; then
         selected_plan="$plan_input"
         break
    else
         print_color "$YELLOW" "❌ Invalid selection. Please try again."
    fi
done
echo ""

# Verify plan file exists
plan_file_path="$PROJECT_ROOT/$selected_project/2-Plans/$selected_plan"
if [ ! -f "$plan_file_path" ]; then
    print_color "$YELLOW" "❌ 找不到計畫檔案: $plan_file_path"
    exit 1
fi

print_color "$GREEN" "✅ 已選擇計畫: $selected_plan"
echo ""

# Generate the complete AI prompt
print_color "$CYAN" "=========================================="
print_color "$CYAN" "📋 完整 AI 提示詞"
print_color "$CYAN" "=========================================="
echo ""

cat << EOF
請執行以下任務：

**⭐ 重要說明：本計畫分為兩個階段**
- **階段 1（第二步）：** 只處理計畫文件的移動和更新，生成 commit 訊息，然後停下來等待確認
- **階段 2（第三步~第四步）：** 等用戶確認「繼續」後，才開始實際的程式碼開發

---

**第一步：讀取計畫檔案**
請讀取 \`$plan_file_path\` 的完整內容。

**第二步：移動並更新計畫檔案（⚠️ 僅處理文件，不開始編寫程式碼）**

請閱讀 \`$PROJECT_ROOT/templates/3-Progressing/PROGRESSING_RULES.md\` 的內容，了解計畫文件更新的流程和規範。

執行以下操作：

1. 將計畫檔案從 \`$PROJECT_ROOT/$selected_project/2-Plans/$selected_plan\` 移動到 \`$PROJECT_ROOT/$selected_project/3-Progressing/$selected_plan\`
   - ⚠️ **重要：** 若計畫位於子資料夾中，請確保在 \`3-Progressing/\` 中建立相對應的子資料夾，以保持資料夾結構一致 (Preserve directory structure)。

2. 更新計畫卡片的以下欄位：
   - **狀態:** 改為「處理中 (Progressing)」
   - **開始處理時間:** 填入當前實際時間（請替換為實際時間，格式: YYYY-MM-DD HH:mm）
   - **負責的 AI 工具 1:** [你的 AI 工具名稱] (填入實際當前時間，格式: YYYY-MM-DD HH:mm ~ )
   - **開發進度:** 新增以下 checklist
     \`\`\`
     - [ ] 計畫文件更新完成
     - [ ] 程式碼框架建立
     - [ ] 核心邏輯實現
     - [ ] 錯誤處理
     - [ ] 完成開發
     \`\`\`
   - **相關程式碼檔案:** 新增此欄位（初始內容為「(開發過程中陸續新增)」）

3. 標記「計畫文件更新完成」為已完成 [✓]

4. 生成一個中文的 commit 訊息（參考 STAGE_02 文件中的範例格式，若無範例則參考 COMMON_CONVENTIONS.md）

5. **⏸️ 停下動作，等待確認**
   提供以下資訊：
   - 已完成的操作清單
   - 建議的 Commit 訊息
   - 提示用戶回覆「繼續」以開始程式碼開發

**❌ 不要繼續執行第三步和第四步，必須等待用戶確認！**

---

**第三步：開始開發（⚠️ 需要用戶確認後才能執行）**

**只有在用戶回覆「繼續」後，才執行以下步驟：**

請閱讀 \`$PROJECT_ROOT/templates/3-Progressing/PROGRESSING_RULES.md\` 的內容，了解開發的流程和規範。

執行實作前，先套用以下規則：

1. 讀取完 Plan 文件並準備開始實作時，優先檢查是否可以同步開始實作。
2. 若任務彼此可並行且無依賴衝突，開啟同步實作模式。
3. 若無法同步開始實作，必須依前後依賴關係逐步執行任務內容。

依照計畫檔案中的「計畫描述」、「需要建立/修改的檔案」等內容，開始實作：

1. 如果計畫卡片中有「參考文件」欄位，請先閱讀相關文件
2. 建立或修改所需的檔案
3. 確保程式碼品質：
   - 所有程式碼識別符（函式名稱、變數名稱）和註釋必須使用完整的英文
   - 實現完整的錯誤處理
   - 遵循專案的代碼風格
4. 在開發過程中持續更新計畫卡片：
   - 更新「相關程式碼檔案」欄位，記錄新建或修改的檔案
   - 更新「開發進度」checklist

**第四步：開發完成檢查**

完成開發後：
1. 確認所有開發進度項目都已勾選
2. 填寫「負責的 AI 工具 1」的結束時間（填入實際當前時間，格式: YYYY-MM-DD HH:mm）
3. 將計畫從 \`3-Progressing/\` 移動到 \`4-Testing/\`
4. 提供開發摘要
5. 停下來等待確認

**⚠️ 重要提醒：**
- 程式碼註解必須使用英文
- 此階段只負責功能開發，不撰寫測試
- 完成後將計畫移到 \`4-Testing/\` (不是 \`7-Done/\`)
- 移入 \`4-Testing/\` 後，下一步必須建立測試程式碼並完成 all green 驗證，不可只停在文件移動
- **🚪 Stage Entry Gate（強制）：** 每次移動文件到新階段後，必須確認來源階段中該批次文件已不存在（使用 mv 而非 cp）。若來源資料夾已無同批次文件，刪除空資料夾。
- **✅ Stage Exit Checkpoint（強制）：** 離開每個階段前，必須先完成所有 checkbox 勾選為 [✓]、補齊工作結果描述、更新 PLAN_OVERVIEW。
- 完成後停下來等待確認

---

現在請開始執行「第一步」和「第二步」。
EOF

echo ""
print_color "$CYAN" "=========================================="
echo ""
print_color "$YELLOW" "💡 提示：複製上面的提示詞（從「請執行以下任務」開始），貼到你的 AI 工具對話框中"
echo ""
print_color "$GREEN" "✅ 計畫檔案位置: $plan_file_path"
print_color "$GREEN" "✅ 執行規則位置: $PROJECT_ROOT/templates/3-Progressing/PROGRESSING_RULES.md"
echo ""
