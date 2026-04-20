#!/bin/bash

# ============================================================================
# Test Execution Prompt Generator
# ============================================================================
# This script generates a complete AI prompt for executing test validation
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

# Function to list plans in 4-Testing folder (recursive)
list_testing_plans() {
    local project=$1
    local testing_dir="$PROJECT_ROOT/$project/4-Testing"

    if [ ! -d "$testing_dir" ]; then
        print_color "$YELLOW" "⚠️  Testing directory not found: $testing_dir"
        return 1
    fi

    # Find all .md files, get relative path from testing_dir
    local plans=()
    while IFS= read -r file; do
        plans+=("$file")
    done < <(cd "$testing_dir" && find . -type f -name "*.md" ! -name ".*" | sed 's|^\./||' | sort)

    if [ ${#plans[@]} -eq 0 ]; then
        print_color "$YELLOW" "⚠️  No plans found in $testing_dir"
        return 1
    fi

    echo "${plans[@]}"
}

# Main script
echo ""
print_color "$CYAN" "=========================================="
print_color "$CYAN" "🧪 AI 測試驗證提示詞產生器"
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
print_color "$CYAN" "🧪 4-Testing/ 中可用的計畫："
plans=($(list_testing_plans "$selected_project"))

if [ ${#plans[@]} -eq 0 ]; then
    print_color "$YELLOW" "⚠️  4-Testing/ 目錄為空，沒有可用的計畫。"
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
plan_file_path="$PROJECT_ROOT/$selected_project/4-Testing/$selected_plan"
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

**⭐ 重要說明：本任務必須先通過 Testing 品質閘門，才可移到 Done**
- 不可先移動到 7-Done 再補測試
- 不可只更新文件而不執行測試
- 必須有測試程式碼、完整測試指令、all green 證據

---

**第一步：讀取計畫檔案**
請讀取 \`$plan_file_path\` 的完整內容。

**第二步：留在 4-Testing 並更新計畫檔案（⚠️ 不可先移到 Done）**

請閱讀 \`$PROJECT_ROOT/templates/7-Done/DONE_RULES.md\` (若存在) 或 COMMON_CONVENTIONS.md 的內容，了解計畫文件更新的流程和規範。

執行以下操作：

1. 更新計畫卡片的「測試進度」欄位（仍在 \`4-Testing/\`）：
   \`\`\`
   - [✓] 測試檔案建立
   - [✓] 單元測試撰寫
   - [✓] 整合測試撰寫（如需要）
   - [✓] 計畫文件更新完成
   - [ ] 測試執行
   - [ ] 測試通過
   \`\`\`
   *(注意：若之前的卡片結構不同，請根據實際情況更新，重點是標記已完成的項目)*

2. 標記「計畫文件更新完成」為已完成 [✓]
3. 立即執行第三步，不可停在文件更新。

---

**第三步：執行測試並收集結果（強制）**

根據專案的測試配置執行測試：

執行實作前，先套用以下規則：

1. 讀取完 Testing 文件並準備開始實作時，優先檢查是否可以同步開始實作。
2. 若任務彼此可並行且無依賴衝突，開啟同步實作模式。
3. 若無法同步開始實作，必須依前後依賴關係逐步執行任務內容。

1. 執行專案完整測試命令（npm test / pytest 等，不可只跑單一測試檔）
2. 收集測試執行結果
3. 執行測試覆蓋率檢查（如果支援）
4. 收集覆蓋率資訊

**第四步：驗證測試品質**

- [ ] 所有測試都通過（成功率 100%）
- [ ] 測試覆蓋率達標（建議 ≥ 80%）
- [ ] 關鍵邏輯都有測試
- [ ] 沒有跳過的測試
- [ ] 測試執行時間合理

**第五步：處理測試失敗（如果有）**

⚠️ **如果需要修改程式碼，必須先處理文件再修改程式：**

根據失敗原因：
- **測試程式碼問題：** 移回 4-Testing/，修正測試程式碼
- **功能程式碼問題：** 移回 3-Progressing/，修正功能程式碼
- **環境問題：** 解決環境問題後重新執行

**第六步：更新計畫卡片並確認在 7-Done**

所有測試通過後：

1. 更新測試進度（全部標記為完成）
2. 填寫「測試負責的 AI 工具」的結束時間（填入實際當前時間，格式: YYYY-MM-DD HH:mm）
3. 新增測試摘要欄位（測試結果、覆蓋率統計等）
4. 將計畫從 \`4-Testing/\` 移動到 \`7-Done/\`，並保持原子資料夾結構
5. 確認計畫已在 7-Done/ 資料夾

**第七步：提供完成摘要**

提供詳細的測試驗證報告，包含：
- 測試執行結果
- 覆蓋率統計
- 品質評估
- 下一步建議

**⚠️ 重要提醒：**
- 必須確保所有測試通過（成功率 100%）
- 如果測試失敗，需要移回 4-Testing/ 或 3-Progressing/
- 測試未全數通過時，禁止移動到 7-Done/ 或 8-Archived/
- **🚪 Stage Entry Gate（強制）：** 每次移動文件到新階段後，必須確認來源階段中該批次文件已不存在（使用 mv 而非 cp）。若來源資料夾已無同批次文件，刪除空資料夾。
- **✅ Stage Exit Checkpoint（強制）：** 離開每個階段前，必須先完成所有 checkbox 勾選為 [✓]、補齊工作結果描述、更新 PLAN_OVERVIEW。
- 完成後停下來等待確認
- 只有在確認測試全部通過後，計畫才能保留在 7-Done/

---

現在請開始執行完整任務流程（第一步到第七步）。
EOF

echo ""
print_color "$CYAN" "=========================================="
echo ""
print_color "$YELLOW" "💡 提示：複製上面的提示詞（從「請執行以下任務」開始），貼到你的 AI 工具對話框中"
echo ""
print_color "$GREEN" "✅ 計畫檔案位置: $plan_file_path"
print_color "$GREEN" "✅ 執行規則位置: $PROJECT_ROOT/templates/7-Done/DONE_RULES.md"
echo ""
