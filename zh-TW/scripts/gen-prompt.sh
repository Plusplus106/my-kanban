#!/bin/bash

# ============================================================================
# Unified Prompt Generator
# ============================================================================
# This script provides a menu to select which stage prompt to generate
# ============================================================================

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function to get list of projects (directories with 1-Specs folder)
get_projects() {
    local projects=()
    for dir in "$SCRIPT_DIR/../"*; do
        local dir_name="$(basename "$dir")"
        if [ -d "$dir" ] && [ -d "$dir/1-Specs" ] && [ "$dir_name" != "templates" ] && [ "$dir_name" != "promps" ] && [ "$dir_name" != "scripts" ]; then
            projects+=("$dir_name")
        fi
    done
    echo "${projects[@]}"
}

# Function to check if there are todo 2-Plans in a specific project
has_todo_plans() {
    local project=$1
    local plan_count=$(find "$SCRIPT_DIR/../$project/2-Plans" -type f -name "*.md" ! -name ".*" 2>/dev/null | wc -l)
    [ "$plan_count" -gt 0 ]
}

# Function to check if there are 3-Progressing 2-Plans in a specific project
has_progressing_plans() {
    local project=$1
    local plan_count=$(find "$SCRIPT_DIR/../$project/3-Progressing" -type f -name "*.md" ! -name ".*" 2>/dev/null | wc -l)
    [ "$plan_count" -gt 0 ]
}

# Function to check if there are 4-Testing 2-Plans in a specific project
has_testing_plans() {
    local project=$1
    local plan_count=$(find "$SCRIPT_DIR/../$project/4-Testing" -type f -name "*.md" ! -name ".*" 2>/dev/null | wc -l)
    [ "$plan_count" -gt 0 ]
}

# Function to check if there are 7-Done 2-Plans in a specific project
has_done_plans() {
    local project=$1
    local plan_count=$(find "$SCRIPT_DIR/../$project/7-Done" -type f -name "*.md" ! -name ".*" 2>/dev/null | wc -l)
    [ "$plan_count" -gt 0 ]
}

# Function to check if 1-Specs folder has non-empty spec folders
has_specs() {
    local project=$1
    local specs_dir="$SCRIPT_DIR/../$project/1-Specs"
    
    # Check if 1-Specs directory exists
    if [ ! -d "$specs_dir" ]; then
        return 1
    fi
    
    # Check if there are any subdirectories in 1-Specs
    local has_folders=false
    for dir in "$specs_dir"/*/; do
        if [ -d "$dir" ]; then
            # Check if the folder has any .md files
            local file_count=$(ls "$dir"*.md 2>/dev/null | wc -l)
            if [ "$file_count" -gt 0 ]; then
                has_folders=true
                break
            fi
        fi
    done
    
    if [ "$has_folders" = true ]; then
        return 0
    else
        return 1
    fi
}

# Function to create new project structure
create_new_project() {
    local project_name=$1
    local project_dir="$SCRIPT_DIR/../$project_name"
    
    print_color "$YELLOW" "正在建立新專案資料夾: $project_name"
    
    # Run the init script
    "$SCRIPT_DIR/init-project-kanban.sh" "$project_name"
    
    print_color "$GREEN" "✅ 專案資料夾 $project_name 已建立"
}

# Main script
echo ""
print_color "$CYAN" "=========================================="
print_color "$CYAN" "🚀 AI 提示詞產生器"
print_color "$CYAN" "=========================================="
echo ""

# Get list of existing projects
projects=($(get_projects))
selected_project=""
is_new_project=false

if [ ${#projects[@]} -eq 0 ]; then
    print_color "$YELLOW" "⚠️  沒有找到任何專案資料夾 (缺少 1-Specs)"
    echo ""
    read -p "請輸入新專案名稱: " project_name
    
    if [ -z "$project_name" ]; then
        print_color "$YELLOW" "❌ 專案名稱不能為空"
        exit 1
    fi
    
    # Check if directory already exists
    if [ -d "$SCRIPT_DIR/../$project_name" ]; then
        print_color "$YELLOW" "❌ 專案資料夾 $project_name 已存在"
        exit 1
    fi
    
    create_new_project "$project_name"
    selected_project="$project_name"
    is_new_project=true
else
    print_color "$BLUE" "請選擇專案："
    echo ""
    for i in "${!projects[@]}"; do
        echo "  $((i+1)). ${projects[$i]}"
    done
    echo ""
    echo "  0. ➕ 建立新專案"
    echo ""
    
    read -p "請選擇專案 (1-${#projects[@]}，或 0 建立新專案): " proj_choice
    
    if [ "$proj_choice" = "0" ]; then
        read -p "請輸入新專案名稱: " project_name
        if [ -z "$project_name" ]; then
            print_color "$YELLOW" "❌ 專案名稱不能為空"
            exit 1
        fi
        
        # Check if directory already exists
        if [ -d "$SCRIPT_DIR/../$project_name" ]; then
            print_color "$YELLOW" "❌ 專案資料夾 $project_name 已存在"
            exit 1
        fi
        
        create_new_project "$project_name"
        selected_project="$project_name"
        is_new_project=true
    elif [ "$proj_choice" -ge 1 ] && [ "$proj_choice" -le ${#projects[@]} ]; then
        selected_project="${projects[$((proj_choice-1))]}"
        is_new_project=false
    else
        print_color "$YELLOW" "❌ 無效的選擇"
        exit 1
    fi
fi

print_color "$GREEN" "✅ 已選擇專案: $selected_project"
echo ""

# Now show stage options based on project
print_color "$BLUE" "請選擇要產生的提示詞類型："
echo ""

# Dynamic menu options
available_stages=()
option_number=1

if $is_new_project; then
    # For new projects, only show STAGE 0
    echo "  $option_number. 💡 STAGE 0: 從 Idea 轉換為 Specs"
    echo "     (idea → spec)"
    echo ""
    available_stages+=("idea-to-spec")
    ((option_number++))
else
    # For existing projects, check what stages are available
    
    # Check if has specs (non-empty 1-Specs/xxx/ folders with .md files)
    if has_specs "$selected_project"; then
        # Has 1-Specs, show STAGE 1 onwards
        echo "  $option_number. 📋 STAGE 1: 從 Specs 建立 Plans"
        echo "     (spec → plan)"
        echo ""
        available_stages+=("spec-to-plan")
        ((option_number++))
    else
        # No 1-Specs or empty 1-Specs, only show STAGE 0
        echo "  $option_number. 💡 STAGE 0: 從 Idea 轉換為 Specs"
        echo "     (idea → spec)"
        echo ""
        available_stages+=("idea-to-spec")
        ((option_number++))
    fi
    
    if has_todo_plans "$selected_project"; then
        echo "  $option_number. 💻 STAGE 2: 執行 Plans 並移到 Progressing"
        echo "     (2-Plans → 3-Progressing)"
        echo ""
        available_stages+=("plan-to-progressing")
        ((option_number++))
    fi
    
    if has_progressing_plans "$selected_project"; then
        echo "  $option_number. 🧪 STAGE 3: 進入 Testing 並完成測試程式碼 + all green"
        echo "     (3-Progressing → 4-Testing)"
        echo ""
        available_stages+=("progressing-to-testing")
        ((option_number++))
    fi
    
    if has_testing_plans "$selected_project"; then
        echo "  $option_number. ✅ STAGE 4: 驗證 testing 證據後移到 Done"
        echo "     (4-Testing → 7-Done)"
        echo ""
        available_stages+=("testing-to-done")
        ((option_number++))
    fi
    
    if has_done_plans "$selected_project"; then
        echo "  $option_number. 📦 STAGE 5: 專案歸檔"
        echo "     (7-Done → 8-Archived)"
        echo ""
        available_stages+=("done-to-archived")
        ((option_number++))
    fi
fi

echo "  0. 🚪 結束/回到 idea-to-spec"
echo ""

read -p "請選擇 (0-${#available_stages[@]}): " choice

# Check for exit commands
if [[ "$choice" =~ ^($'\e'|esc|exit|0)$ ]]; then
     # For 0, also provide option to go back to idea-to-spec if needed
     if [ "$choice" == "0" ] && [ "${available_stages[0]}" != "idea-to-spec" ]; then
        read -p "是否要回到 idea-to-spec? (y/n): " force_idea
        if [[ "$force_idea" =~ ^(y|Y|yes)$ ]]; then
            exec "$SCRIPT_DIR/gen-idea-to-spec-prompt.sh" "$selected_project"
        fi
     fi
    print_color "$GREEN" "謝謝您的使用，再見！"
    exit 0
fi

if [ "$choice" -ge 1 ] && [ "$choice" -le ${#available_stages[@]} ]; then
    stage="${available_stages[$((choice-1))]}"
    case $stage in
        "idea-to-spec")
            print_color "$GREEN" "✅ 已選擇：STAGE 0 - 從 Idea 轉換為 Specs"
            echo ""
            exec "$SCRIPT_DIR/gen-idea-to-spec-prompt.sh" "$selected_project"
            ;;
        "spec-to-plan")
            print_color "$GREEN" "✅ 已選擇：STAGE 1 - 從 Specs 建立 Plans"
            echo ""
            exec "$SCRIPT_DIR/gen-spec-to-plan-prompt.sh" "$selected_project"
            ;;
        "plan-to-progressing")
            print_color "$GREEN" "✅ 已選擇：STAGE 2 - 執行 Plans"
            echo ""
            exec "$SCRIPT_DIR/gen-plan-to-progressing-prompt.sh" "$selected_project"
            ;;
        "progressing-to-testing")
            print_color "$GREEN" "✅ 已選擇：STAGE 3 - 撰寫測試程式碼"
            echo ""
            exec "$SCRIPT_DIR/gen-progressing-to-testing-prompt.sh" "$selected_project"
            ;;
        "testing-to-done")
            print_color "$GREEN" "✅ 已選擇：STAGE 4 - 執行測試驗證"
            echo ""
            exec "$SCRIPT_DIR/gen-testing-to-done-prompt.sh" "$selected_project"
            ;;
        "done-to-archived")
            print_color "$GREEN" "✅ 已選擇：STAGE 5 - 專案歸檔"
            echo ""
            exec "$SCRIPT_DIR/gen-done-to-archived-prompt.sh" "$selected_project"
            ;;
    esac
else
    print_color "$YELLOW" "❌ 無效的選擇"
    exit 1
fi
