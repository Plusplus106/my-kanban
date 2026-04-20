#!/bin/bash

# ============================================================================
# Progressing to Testing Prompt Generator
# ============================================================================
# This script generates a complete AI prompt for moving plans to 4-Testing
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

# Function to list plans in 3-Progressing folder (recursive)
list_progressing_plans() {
    local project=$1
    local progressing_dir="$PROJECT_ROOT/$project/3-Progressing"

    if [ ! -d "$progressing_dir" ]; then
        print_color "$YELLOW" "⚠️  Progressing directory not found: $progressing_dir"
        return 1
    fi

    # Find all .md files, get relative path from progressing_dir
    local plans=()
    while IFS= read -r file; do
        plans+=("$file")
    done < <(cd "$progressing_dir" && find . -type f -name "*.md" ! -name ".*" | sed 's|^\./||' | sort)

    if [ ${#plans[@]} -eq 0 ]; then
        print_color "$YELLOW" "⚠️  No plans found in $progressing_dir"
        return 1
    fi

    echo "${plans[@]}"
}

# Main script
echo ""
print_color "$CYAN" "=========================================="
print_color "$CYAN" "🧪 STAGE 03: 撰寫測試程式碼提示詞產生器"
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
print_color "$CYAN" "📋 3-Progressing/ 中可用的計畫："
plans=($(list_progressing_plans "$selected_project"))

if [ ${#plans[@]} -eq 0 ]; then
    print_color "$YELLOW" "⚠️  3-Progressing/ 目錄為空，沒有可用的計畫。"
    echo ""
    read -p "是否需要協助產生其他階段的計畫？ (y/n): " help_choice
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
plan_file_path="$PROJECT_ROOT/$selected_project/3-Progressing/$selected_plan"
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

**⭐ 重要說明：本流程一旦移入 4-Testing，就必須完成 Testing 品質閘門**
- 不可只移動計畫文件後就停止
- 必須建立測試程式碼並執行完整測試範圍
- 只有全部測試通過（all green）才可移到 7-Done

---

**第一步：讀取計畫檔案**
請讀取 \`$plan_file_path\` 的完整內容。

**第二步：移動並更新計畫檔案（⚠️ 不可只處理文件）**

請閱讀 \`$PROJECT_ROOT/templates/4-Testing/TESTINGS_RULES.md\` (若存在) 或 COMMON_CONVENTIONS.md，了解計畫文件更新的流程和規範。

執行以下操作：

1. 將計畫檔案從 \`$PROJECT_ROOT/$selected_project/3-Progressing/$selected_plan\` 移動到 \`$PROJECT_ROOT/$selected_project/4-Testing/$selected_plan\`
   - ⚠️ **重要：** 若計畫位於子資料夾中，請確保在 \`4-Testing/\` 中建立相對應的子資料夾，以保持資料夾結構一致 (Preserve directory structure)。

2. 更新計畫卡片的以下欄位：
   - **狀態:** 改為「測試中 (Testing)」
   - **測試負責的 AI 工具:** [你的 AI 工具名稱] (填入實際當前時間，格式: YYYY-MM-DD HH:mm ~ )
   - **測試進度:** 新增以下 checklist
     \`\`\`
     - [ ] 計畫文件更新完成
     - [ ] 測試 module 檢查與安裝
     - [ ] 環境配置檢查（如需要外部服務）
     - [ ] 測試檔案建立
     - [ ] 單元測試撰寫
     - [ ] 整合測試撰寫（⚠️ 只有實際執行整合測試時才勾選）
     - [ ] 測試執行
     - [ ] 使用 4-Testing/temp/ 測試資料驗證（如有測試資料）
     - [ ] 測試通過
     \`\`\`
   - **環境配置狀態:** 新增以下欄位（如測試需要連接外部服務）
     \`\`\`
     - 測試環境 URL: [已配置 / 未配置 / 不適用]
     - 正式環境 URL: [已配置 / 未配置 / 不適用]
     - 資料庫連接: [已配置 / 未配置 / 不適用]
     - 其他外部服務: [已配置 / 未配置 / 不適用]
     - 備註: [如有環境配置問題，在此說明]
     \`\`\`

3. 標記「計畫文件更新完成」為已完成 [✓]

4. 生成一個英文的 commit 訊息（參考 STAGE_03 文件中的範例格式）

5. 立即開始第三步，不可停在「只更新文件」狀態。

---

**第三步：開始撰寫測試程式碼（強制）**

請閱讀 \`$PROJECT_ROOT/promps/STAGE_03_PROGRESSING_TO_TESTING.md\` 的「第三步」內容（雖然檔名未改，但規範適用），了解測試程式碼撰寫的流程和規範。

執行實作前，先套用以下規則：

1. 讀取完 Testing 文件並準備開始實作時，優先檢查是否可以同步開始實作。
2. 若任務彼此可並行且無依賴衝突，開啟同步實作模式。
3. 若無法同步開始實作，必須依前後依賴關係逐步執行任務內容。

依照計畫檔案中的「相關程式碼檔案」，開始撰寫測試：

1. **⭐ 檢查並安裝測試相關 module（重要！在撰寫測試前必須先執行）**
   - 檢查專案的測試框架和工具是否已安裝
   - React/RN 專案：檢查 package.json 是否包含 jest, @testing-library 等
   - Python 專案：檢查是否已安裝 pytest, pytest-cov 等
   - 如果缺少必要的 module，先安裝後再繼續
   - 在計畫卡片的「測試進度」中記錄 module 安裝情況

2. **⭐ 檢查測試環境或正式環境的網址（如測試需要連接外部服務）**
   - 檢查專案的環境配置檔案（.env, config.json 等）
   - 確認測試機 URL 或正式機 URL 是否已配置
   - ⚠️ 如果找不到環境配置：
     * 在計畫文件中說明「目前找不到測試機或正式機的環境配置，暫時跳過需要外部環境的整合測試」
     * 評估只執行不需要外部環境的單元測試或使用 mock 的測試
     * 在「測試進度」中標記為「部分完成（缺少環境配置）」
     * 停下來詢問用戶是否有環境配置資訊，或是否要將計畫移到 6-On-hold/

3. **⭐ 遇到錯誤時參考專案文件**
   - 如果在測試過程中遇到任何錯誤或不確定的問題
   - 先閱讀專案內的文件尋找解決方案：
     * README.md - 專案說明、安裝步驟、測試執行方式
     * docs/ 資料夾 - API 文件、架構說明、測試指南
     * CONTRIBUTING.md - 開發和測試規範
     * package.json 或 pyproject.toml - 測試指令和依賴
     * 測試配置檔 - jest.config.js, pytest.ini, .env.test 等
   - 從專案文件中可以找到正確的處理方式、環境設定、已知問題和解決方案

4. 讀取計畫卡片中的「相關程式碼檔案」，了解需要測試的程式碼

5. 建立對應的測試檔案

6. 撰寫單元測試：
   - 測試主要功能的正常情況
   - 測試邊界情況
   - 測試錯誤處理
   - 所有測試程式碼註解必須使用英文

7. 如有需要，撰寫整合測試

8. 在測試過程中持續更新計畫卡片：
   - 更新「測試進度」checklist
   - 記錄測試檔案位置

**第四步：執行測試並更新計畫文件（⭐ 重要！）**

完成測試程式碼撰寫後：

1. **執行前檢查（環境配置）**
   - 如果是純單元測試（不需要外部服務）→ 直接執行測試
   - 如果需要連接 API 或資料庫 → 檢查環境配置是否完整
   - 如果缺少環境配置 → 使用 mock 或標記為「部分完成」並在計畫文件中記錄

2. **執行測試**
   - 使用對應的測試指令執行完整測試範圍（npm test / pytest 等）
   - 不可只跑單一測試檔就視為完成
   - 收集測試執行輸出
   - 記錄測試統計資訊（通過數、失敗數、覆蓋率等）
   - ⚠️ 如果因缺少環境配置而跳過某些測試，在測試結果中明確說明

3. **⭐ 使用 4-Testing/temp/ 測試資料進行驗證測試（如有測試資料）**
   - 檢查 \`$PROJECT_ROOT/$selected_project/4-Testing/temp/\` 是否有測試資料
   - 如果有測試資料（audio/、data/、images/、scripts/），使用這些實際檔案再次執行驗證測試
   - 記錄驗證測試結果（驗證了幾個檔案）
   - 如果沒有測試資料，在測試進度中標記為「不適用」

4. **⭐ 測試執行完成後，立即更新計畫文件（重要！）**
   - 完成所有「測試進度」項目的勾選（包含驗證測試項目）
   - 填寫「測試負責的 AI 工具」的結束時間（填入實際當前時間，格式: YYYY-MM-DD HH:mm）
   - 在計畫文件末尾新增「測試結果」區塊，包含：
     * 測試完成時間
     * 測試結果（通過/失敗）
     * 測試覆蓋率
     * 測試統計（總數、通過、失敗、成功率）
     * 測試執行輸出（完整的終端輸出）
     * 驗證測試結果（如有執行）
   - 確保「測試程式碼檔案」欄位完整記錄所有測試檔案

5. **生成測試完成的 Commit 訊息**
   範例格式：
   \`\`\`
   test([project-name]): complete 4-Testing for [plan-name]

   - All tests passed (X/X test cases)
   - Test coverage: XX%
   - Verified with 4-Testing/temp/ data (X files tested)
   - Update plan file with test results
   - Mark 4-Testing progress as completed
   \`\`\`

6. **移動計畫到 7-Done/ 資料夾**
   - 只有在全部測試通過（all green）時，才將計畫從 \`4-Testing/\` 移動到 \`7-Done/\`

7. **停下來等待確認**
   - 提供測試結果摘要
   - 提供驗證測試結果（如有執行）
   - 提供計畫文件更新內容清單
   - 提供建議的 Commit 訊息

**⚠️ 重要提醒：**
- 所有測試程式碼註解必須使用英文
- **測試執行完成後必須立即更新計畫文件**
- 計畫文件更新包含測試結果的完整記錄
- **測試未全數通過時，不可移動到 7-Done 或 8-Archived**
- **🚪 Stage Entry Gate（強制）：** 每次移動文件到新階段後，必須確認來源階段中該批次文件已不存在（使用 mv 而非 cp）。若來源資料夾已無同批次文件，刪除空資料夾。
- **✅ Stage Exit Checkpoint（強制）：** 離開每個階段前，必須先完成所有 checkbox 勾選為 [✓]、補齊工作結果描述、更新 PLAN_OVERVIEW。
- 完成後停下來等待確認

---

現在請開始執行完整任務流程（第一步到第四步）。
EOF

echo ""
print_color "$CYAN" "=========================================="
echo ""
print_color "$YELLOW" "💡 提示：複製上面的提示詞（從「請執行以下任務」開始），貼到你的 AI 工具對話框中"
echo ""
print_color "$GREEN" "✅ 計畫檔案位置: $plan_file_path"
print_color "$GREEN" "✅ 執行規則位置: $PROJECT_ROOT/promps/STAGE_03_PROGRESSING_TO_TESTING.md"
echo ""
