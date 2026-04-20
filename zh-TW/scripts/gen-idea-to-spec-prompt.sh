#!/bin/bash

# ============================================================================
# Idea to Spec Prompt Generator
# ============================================================================
# This script generates a complete AI prompt with idea-to-spec guides
# to enable AI to discover project needs through conversation
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
# Update path to specs templates
TEMPLATES_DIR="$PROJECT_ROOT/templates/specs" 

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

print_color "$CYAN" "╔═══════════════════════════════════════════════════════════════╗"
print_color "$CYAN" "║         📝 Idea to Spec Prompt Generator                      ║"
print_color "$CYAN" "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Select project
if [ -n "$1" ]; then
    project="$1"
    # Verify project exists
    if [ ! -d "$PROJECT_ROOT/$project/1-Specs" ]; then
         print_color "$YELLOW" "❌ Project not found or invalid: $project"
         exit 1
    fi
    print_color "$GREEN" "✅ Selected project: $project"
else
    # Use select menu for project selection
    print_color "$GREEN" "📂 Available Projects:"
    projects=($(list_projects))

    if [ ${#projects[@]} -eq 0 ]; then
        print_color "$YELLOW" "⚠️  No projects with 1-Specs found."
        exit 1
    fi

    PS3="Select project (number): "
    select proj_select in "${projects[@]}"; do
        if [ -n "$proj_select" ]; then
            project="$proj_select"
            print_color "$GREEN" "✓ Selected project: $project"
            break
        else
             print_color "$YELLOW" "❌ Invalid selection. Please try again."
        fi
    done
fi
echo ""

# Step 2: Select spec folder
print_color "$GREEN" "📁 Available Specs in $project:"
specs=($(list_specs_folders "$project"))

if [ ${#specs[@]} -eq 0 ]; then
    print_color "$YELLOW" "⚠️  No 1-Specs found in $project"
    exit 1
fi

PS3="Select spec folder (number): "
select spec in "${specs[@]}"; do
    if [ -n "$spec" ]; then
        print_color "$GREEN" "✓ Selected spec: $spec"
        break
    else
         print_color "$YELLOW" "❌ Invalid selection. Please try again."
    fi
done
echo ""

SPEC_DIR="$PROJECT_ROOT/$project/1-Specs/$spec"

# ============================================================================
# Generate Prompt
# ============================================================================

print_color "$CYAN" "🔨 Generating prompt..."
echo ""

# Output file
OUTPUT_FILE="$SPEC_DIR/${spec}-IDEA_TO_SPEC_PROMPT.md"

# Start generating the prompt
cat > "$OUTPUT_FILE" << 'EOF'
# AI 引導式 Idea 收集 Prompt

你是專業的需求分析 AI,透過問答收集使用者 idea 並產生 IDEA_DESCRIPTION.md (以及其他規格文件)。

---

## 📚 請閱讀以下指南

EOF

# Append SPECS_RULES.md
print_color "$CYAN" "📄 Including SPECS_RULES.md..."
cat >> "$OUTPUT_FILE" << EOF

\`\`\`markdown
EOF
cat "$TEMPLATES_DIR/SPECS_RULES.md" >> "$OUTPUT_FILE"
cat >> "$OUTPUT_FILE" << EOF
\`\`\`

---

EOF

# Add final instructions
cat >> "$OUTPUT_FILE" << 'EOF'

## 🚀 開始對話

現在請開始引導我描述 idea。

**記住:**
- ✅ 最多 8 個問題,視情況調整
- ✅ 已獲得足夠資訊可提前結束
- ✅ 必須產生 `[spec-xxxxx]-IDEA_DESCRIPTION.md`
- ✅ 必須產生 `[spec-xxxxx]-CLEANUP_AND_INTEGRATION.md`
- ✅ 視需求產生其他設計文件 (如 API_DESIGN, DATABASE_SCHEMA 等)
- ✅ 記錄完整對話

---

## 💬 我的 Idea

[請描述你的 idea, AI 會開始提問]

EOF


# ============================================================================
# Summary
# ============================================================================

print_color "$GREEN" "✅ Idea 收集 Prompt 已產生!"
echo ""
print_color "$CYAN" "📄 檔案: $OUTPUT_FILE"
echo ""
print_color "$YELLOW" "使用步驟:"
echo "   1. 開啟並複製 prompt 給 AI"
echo "   2. 描述 idea, AI 會提問 (最多 8 個問題)"
echo "   3. AI 產生 [spec-xxxxx]-IDEA_DESCRIPTION.md 等規格文件"
echo "   4. 下一步: 任務拆解 (參考 templates/1-Specs/SPECS_RULES.md)"
echo ""
print_color "$CYAN" "╔═══════════════════════════════════════════════════════════════╗"
print_color "$CYAN" "║                    🎉 完成!                                    ║"
print_color "$CYAN" "╚═══════════════════════════════════════════════════════════════╝"
