---
name: git-add-and-gen-commit-message
description: 針對本次對話中 AI 實際修改的檔案，產生詳細完整的 commit message，並在允許範圍內自動執行 git add。若使用者提供明確檔案或資料夾路徑，僅掃描該路徑範圍。適用於需要避免誤 add 其他暫存或無關修改的情境。
version: 1.1.0
last_updated: 2026-02-15
effective_date: 2026-02-15
---

# Git Add And Generate Commit Message

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

在不誤傷無關變更的前提下，完成兩件事：

- 產生一段詳細且完整的英文 commit message。
- 針對允許範圍內檔案主動執行 `git add`。

## 快速使用範例

- 觸發：`$git-add-and-gen-commit-message`
- 產生 commit message：直接描述需求。
- 語言切換：若需求中包含 `中文commit`、`zh`、`tw commit`，改產生中文 commit。
- 執行 add：啟用 skill 後自動執行（僅限允許範圍）。

## 觸發語意

- 需求包含「生成 commit message」時：預設產生英文 commit message，並在允許範圍內自動執行 git add。
- 若使用者訊息含 `中文commit`、`zh`、`tw commit` 關鍵字：改產生中文 commit message（繁體中文台灣用語）。
- 啟用 skill 後，應主動執行 `git add`（僅限允許範圍）。
- 若使用者有提供明確檔案/資料夾路徑：只掃描該路徑內變更，不得掃描路徑外。

## 必做步驟

1. 建立本次對話的檔案範圍

- 優先檢查是否有使用者提供的明確檔案/資料夾路徑：
  - 若有：in-scope 僅允許該路徑範圍內變更。
  - 若無：才使用「本次對話中 AI 實際修改過的檔案」作為 in-scope 來源。
- 若有提供路徑，禁止掃描或比對路徑以外任何檔案。
- 收斂「本次對話範圍內檔案」為 in-scope 清單。
- 執行 `git status --porcelain` 取得變更檔案時，需限制在允許範圍（提供路徑時即路徑範圍）。
- 比對後拆成兩類：
  - in-scope（可納入本次任務）
  - out-of-scope（不可動，視為其他需求或暫存修改）

2. 產生 commit message（預設模式）

- 預設只輸出 commit message，不執行 git add/commit/push。
- commit message 語言規則：
  - 預設英文。
  - 若命中關鍵字 `中文commit`、`zh`、`tw commit`，改用中文（繁體中文台灣用語）。
- commit message 必須遵循 Conventional Commits：
  - `<type>(<scope>): <subject>`
  - `body`
  - `footer`
- 內容需詳細且完整，至少包含：
  - 主要修改目的
  - 重要行為變更
  - 涉及檔案與影響面
  - 測試或驗證結果（若有）
- 若已知對應 task 文件，必須在 body 或 footer 標註 task 檔名；若未知則省略。

3. 自動 add 模式（預設）

- 只可 add in-scope 清單內檔案。
- 禁止使用 `git add .`、`git add -A`、`git add --all`。
- 必須以明確檔案路徑執行 `git add <file1> <file2> ...`。
- add 後必須檢查 staged 結果（例如 `git diff --staged --name-only`），確認沒有 out-of-scope 檔案被加入。

4. 回報格式

- 回報：
  - 已 add 檔案清單
  - 明確說明未 add 的 out-of-scope 檔案（若有）
  - commit message 內容

## 禁止事項

- 永遠禁止執行 `git commit` 或 `git push`。
- 禁止 add out-of-scope 檔案。
- 若無法可靠判定 in-scope 清單，必須先停下並請使用者確認檔案清單。
