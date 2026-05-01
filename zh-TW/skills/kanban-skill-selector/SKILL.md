---
name: kanban-skill-selector
description: 高階入口 skill，先讓使用者從多個 kanban skills 中選一個，再進入該 skill 的問答流程。適用於希望先做技能層級選擇，再執行各自流程的情境。
version: 2.1.0
last_updated: 2026-05-01
effective_date: 2026-05-01
---

# Kanban Skill Selector

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

作為 skills 入口選單：先選要用哪個 skill，再交由該 skill 的問答流程執行。

## 快速使用範例

- 觸發：`$kanban-skill-selector`
- 回覆：先選第一層 skill 編號，再進入子流程。

## 執行前置

- 先完成第一層 skill 選擇，再套用子 skill 自己的流程規則。

## 第一層選單（可用數字回答）

請先詢問使用者要使用哪個 skill：

**建立階段（Create Flow）**

- `1. kanban-create-specs-only` — 建立 Spec 文件，確認後停止
- `2. kanban-create-specs-then-breakdown-to-plans` — 建立 Spec，確認後拆解成 Plans，完成後停止
- `3. kanban-create-specs-then-push-to-archived` — 建立 Spec → Plans → 自動推進到 Archived
- `4. kanban-create-plans-only` — 直接建立 Plan 文件，完成後停止
- `5. kanban-create-plans-then-push-to-archived` — 建立 Plans，確認後自動推進到 Archived
- `6. kanban-create-testing-only` — 建立 Testing 文件與執行測試，完成後停止
- `7. kanban-create-testing-then-push-to-archived` — 建立 Testing，確認後自動推進到 Archived

**既有文件推進（Exist Flow）**

- `8. kanban-exist-specs-push-to-archived` — 接收既有 Spec，拆解 Plans，確認後推進到 Archived
- `9. kanban-exist-plans-push-to-archived` — 接收既有 Plans，直接推進到 Archived
- `10. kanban-exist-testing-push-to-archived` — 接收既有 Testing，直接推進到 Archived

**歸檔與驗證**

- `11. kanban-archive-only` — 確認 Done 文件完成後，執行歸檔搬移
- `12. kanban-verify-completed-task` — 針對已完成任務進行至少三次品質交叉驗證

**工具**

- `13. git-add-and-gen-commit-message` — 針對修改的檔案自動產生 commit message（支援語言參數：zh/en/jp 等，預設英文）
- `14. git-smart-batch-commit` — 掃描所有變動檔案，依功能分組，分批產生英文 commit message，等待確認後才執行，嚴禁自動 push

## 分流規則

- 使用者選定後，立即進入對應 skill 的問答與流程規範。
- 進入子 skill 後，完全遵循子 skill 的問答與流程規範。
- 若子流程會進入 `4-Testing`，必須遵守 Testing 品質閘門（測試程式碼 + 完整測試 + all green + 文件證據）。
- 若選項不存在或檔案缺失，停止並回報缺失項目。

## 禁止事項

- 未完成第一層選單，不得直接假設要走哪個 skill。
- 不得跳過子 skill 的前置檢查與問答流程。
