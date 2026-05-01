---
name: git-add-and-gen-commit-message
description: 針對本次對話中 AI 實際修改的檔案，產生詳細完整的 commit message，並在允許範圍內自動執行 git add。支援透過明確語言參數（如 zh、en、jp 或中文、英文、日文）指定 commit message 語言。若使用者提供明確檔案或資料夾路徑，僅掃描該路徑範圍。
version: 1.2.0
last_updated: 2026-05-01
effective_date: 2026-05-01
---

# Git Add And Generate Commit Message

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

在不誤傷無關變更的前提下，完成兩件事：

- 產生一段詳細且完整的 commit message（語言由參數決定，預設英文）。
- 針對允許範圍內檔案主動執行 `git add`。

## 快速使用範例

- 觸發（無參數）：`$git-add-and-gen-commit-message`
- 觸發（含路徑）：`$git-add-and-gen-commit-message /path/to/folder`
- 觸發（含路徑 + 語言）：`$git-add-and-gen-commit-message /path/to/folder zh`
- 觸發（含路徑 + 語言全名）：`$git-add-and-gen-commit-message /path/to/folder 日文`
- 語言切換（關鍵字方式）：若需求中包含 `中文commit`、`zh`、`tw commit`，亦可觸發語言切換（優先級低於明確參數）。
- 執行 add：啟用 skill 後自動執行（僅限允許範圍）。

## 觸發語意

- 需求包含「生成 commit message」時：預設產生英文 commit message，並在允許範圍內自動執行 git add。
- 使用者可提供兩個參數：`路徑`（第一參數）與 `語言`（第二參數）。
- 啟用 skill 後，應主動執行 `git add`（僅限允許範圍）。
- 若使用者有提供明確檔案/資料夾路徑：只掃描該路徑內變更，不得掃描路徑外。

## 語言參數對應表

明確語言參數（第二參數）優先級高於關鍵字偵測，支援以下輸入形式：

| 輸入值（不分大小寫） | 對應語言 | 說明 |
|---|---|---|
| `zh`、`zh-tw`、`tw`、`中文`、`繁體中文`、`chinese` | 繁體中文（台灣用語） | |
| `zh-cn`、`cn`、`简体中文`、`簡體中文` | 簡體中文 | |
| `en`、`english`、`英文`、`英語` | 英文 | 預設值 |
| `jp`、`ja`、`japanese`、`日文`、`日語`、`日本語` | 日文 | |
| `ko`、`korean`、`韓文`、`韓語` | 韓文 | |
| 其他未知值 | 視為英文（預設） | 並輸出警告提示 |

**語言優先級順序（由高到低）：**
1. 明確語言參數（第二參數）
2. 訊息中的關鍵字偵測（`中文commit`、`zh`、`tw commit` 等）
3. 預設英文

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

2. 解析語言設定

- 依照「語言優先級順序」決定 commit message 使用語言：
  1. 優先檢查第二參數（若有），對照「語言參數對應表」解析目標語言。
  2. 若無第二參數，掃描使用者訊息是否含 `中文commit`、`zh`、`tw commit` 等關鍵字。
  3. 以上皆無，則預設使用英文。
- 若第二參數無法對應任何已知語言，輸出警告（「無法識別語言參數 xxx，已使用預設英文」）並繼續。

3. 產生 commit message（預設模式）

- 預設只輸出 commit message，不執行 git add/commit/push。
- commit message 語言依步驟 2 解析結果決定。
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

4. 自動 add 模式（預設）

- 只可 add in-scope 清單內檔案。
- 禁止使用 `git add .`、`git add -A`、`git add --all`。
- 必須以明確檔案路徑執行 `git add <file1> <file2> ...`。
- add 後必須檢查 staged 結果（例如 `git diff --staged --name-only`），確認沒有 out-of-scope 檔案被加入。

5. 回報格式

- 回報：
  - 使用的 commit message 語言（及來源：參數 / 關鍵字 / 預設）
  - 已 add 檔案清單
  - 明確說明未 add 的 out-of-scope 檔案（若有）
  - commit message 內容

## 禁止事項

- 永遠禁止執行 `git commit` 或 `git push`。
- 禁止 add out-of-scope 檔案。
- 若無法可靠判定 in-scope 清單，必須先停下並請使用者確認檔案清單。
