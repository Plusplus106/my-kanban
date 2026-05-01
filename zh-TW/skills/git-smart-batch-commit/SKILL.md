---
name: git-smart-batch-commit
description: 掃描 repo 中所有已變動的檔案，依照功能/類別自動分組，為每個分組產生詳細的英文 commit message。產出後強制暫停等待使用者確認，使用者確認指定批次後才依序執行 git add + commit，絕對嚴格禁止自動 push。
version: 1.0.0
last_updated: 2026-05-01
effective_date: 2026-05-01
---

# Git Smart Batch Commit

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

當同一個 repo 一次混入了多個不同功能的修改，自動將變動檔案依類別分組，為每組產生獨立、詳細的英文 commit message，並在使用者明確確認後才逐批執行 git add + commit。

## 快速使用範例

- 觸發（無參數）：`$git-smart-batch-commit`
- 觸發（含路徑）：`$git-smart-batch-commit /path/to/repo`
- AI 產出分組與 commit message 後：**強制暫停，等待使用者確認**。
- 使用者確認後輸入例如：

  > 現在我同意你，依序依照批次，git add and git commit，先完成 1 and 2

  AI 才依序執行指定的批次。

## 觸發語意

- 啟用 skill 後，立即進入「掃描 → 分組 → 產生 commit message → 強制暫停」流程。
- 若使用者有提供路徑：僅掃描該路徑範圍內的變動；否則從 repo 根目錄掃描。
- commit message 語言：**固定英文**，不受其他參數影響。
- 分組完成並產出 commit message 後：**絕對必須停下等待使用者確認，嚴禁自動執行任何 git 操作**。

## 必做步驟

### 階段一：掃描與分組（自動執行）

1. 執行 `git status --porcelain`（限定於指定路徑範圍，若無指定則為 repo 根目錄），取得所有已變動的檔案清單。

2. 對每一個變動檔案，執行 `git diff HEAD -- <file>` 或 `git diff --cached -- <file>`（視檔案狀態而定），讀取實際修改內容（diff）。

3. 依照修改內容與路徑語意，將所有檔案分組，分組原則如下：
   - **盡可能細拆**：同一功能點的修改歸一組，避免多個不相關功能混入同一批次。
   - 分組依據（參考順序）：
     1. 功能語意（例如：auth 流程、UI 元件、API 邏輯、資料庫 schema、CI/CD 設定）
     2. 路徑結構（例如：`src/auth/`、`src/ui/`、`.github/`）
     3. 修改目的（例如：bugfix、refactor、feat、chore、docs）
   - 若某個檔案難以歸類，單獨列為一組並標註 `[需確認]`。

4. 輸出分組結果，格式如下：

   ```
   === 變動檔案分組結果 ===

   【批次 1】<功能簡述>
   - path/to/file1.ts
   - path/to/file2.ts

   【批次 2】<功能簡述>
   - path/to/file3.ts

   ...（依此類推）
   ```

### 階段二：產生 commit message（自動執行）

5. 針對每個批次，依照批次內檔案的實際 diff 內容，產生一段詳細且完整的英文 commit message。

6. commit message 格式必須遵循 Conventional Commits：
   ```
   <type>(<scope>): <subject>

   <body>

   <footer>
   ```
   - `type`：`feat`、`fix`、`refactor`、`chore`、`docs`、`test`、`style`、`ci` 等
   - `body`：至少包含主要修改目的、重要行為變更、涉及檔案與影響面
   - `footer`：若已知對應 task 文件，必須標註 task 檔名；若未知則省略

7. 輸出所有批次的 commit message，格式如下：

   ```
   === Commit Message 草稿 ===

   【批次 1】
   feat(auth): implement token refresh logic

   - Add automatic token refresh in AuthService
   - Handle 401 responses globally in HTTP interceptor
   - Affected files: src/auth/auth.service.ts, src/interceptors/http.interceptor.ts

   Task: [plan-XXXXX]-auth-token-refresh.md

   ---

   【批次 2】
   ...
   ```

### 階段三：強制暫停（必須遵守）

8. **輸出完所有分組與 commit message 後，必須立即停止，絕對不可自動執行任何 git 操作。**

9. 輸出以下等待確認提示：

   ```
   ✅ 已完成分組與 commit message 草稿。

   請確認以上內容是否正確：
   - 如需調整分組或 commit message，請告知。
   - 若確認無誤，請告訴我要執行哪些批次，例如：
     「現在我同意你，依序依照批次，git add and git commit，先完成 1 and 2」

   ⚠️ 在收到你的明確確認前，我不會執行任何 git 操作。
   ```

### 階段四：依序執行（使用者確認後才執行）

10. 收到使用者確認訊息後，**只執行使用者明確指定的批次編號**，其餘批次繼續等待。

11. 對每個指定批次，依序執行：
    - `git add <file1> <file2> ...`（僅限該批次的檔案，絕對禁止使用 `git add .`、`git add -A`、`git add --all`）
    - 執行 `git diff --staged --name-only`，確認 staged 檔案與該批次完全一致，無多餘檔案。
    - 執行 commit 時，commit message 含有多行（subject + body + footer），必須使用多個 `-m` 參數分段傳入，例如：
      ```
      git commit -m "<type>(<scope>): <subject>" -m "<body>" -m "<footer>"
      ```
      確保 subject、body、footer 各自獨立段落，不可壓縮成單行。

12. 每個批次 commit 完成後，立即回報結果，格式如下：
    ```
    ✅ 批次 1 已完成 commit。
    Commit hash: <hash>
    Files committed: file1.ts, file2.ts
    ```

13. 全部指定批次完成後，若仍有未執行的批次，提示使用者：
    ```
    ⏸ 批次 3、4 尚未執行，請告訴我是否繼續。
    ```

## 禁止事項

> ⛔ 以下規則為最高優先級，任何情況下均不得違反。

- **永遠嚴格禁止執行 `git push`，無論使用者是否要求，無論任何理由，絕無例外。**
- **禁止在使用者明確確認前，執行任何 `git add` 或 `git commit`。**
- 禁止使用 `git add .`、`git add -A`、`git add --all`，必須逐一列出檔案路徑。
- 禁止將不同批次的檔案混在同一個 commit 中。
- 禁止跳過「強制暫停等待確認」步驟，即使使用者沒有明確要求暫停也必須暫停。
- 若 staged 結果中出現非該批次的檔案，必須立即中止並告知使用者，等待指示。
- 禁止在同一次指令中連續執行多個批次（除非使用者在同一則確認訊息中明確指定多個批次）。
