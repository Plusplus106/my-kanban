# Kanban Skills 總覽

本資料夾集中管理可重用的 Kanban skills。

## 路徑基準

本資料夾與對應文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 使用方式

1. 在對話中輸入對應觸發字串（例如 `$kanban-skill-selector`）。
2. 依 skill 問答流程回覆，可直接用數字（例如 `1`、`2`）。
3. 所有流程只要進入 `4-Testing`，都必須通過 Testing 品質閘門（測試程式碼 + 完整測試 + all green + 文件證據）才可推進到 `7-Done/8-Archived`。
4. 所有走到 `8-Archived` 的流程，歸檔後會自動執行「專案文件更新」，找到對應文件自動同步，找不到路徑時才停下請使用者提供。

## Skills 清單

### 入口選單

- `kanban-skill-selector`
  - 觸發：`$kanban-skill-selector`
  - 用途：第一層選單入口，先選 skill 再分流。

### 建立階段（Create Flow）

- `kanban-create-specs-only`
  - 觸發：`$kanban-create-specs-only`
  - 用途：建立 Spec 文件，確認後停止，不自動往下推進。
  - 問答：目的地路徑、需求敘述或討論

- `kanban-create-specs-then-breakdown-to-plans`
  - 觸發：`$kanban-create-specs-then-breakdown-to-plans`
  - 用途：建立 Spec，確認後拆解成 Plans，拆解完成後停止。
  - 問答：目的地路徑、需求敘述或討論
  - 停頓點：⏸️ Spec 確認 → ⏸️ Plans 完成後停止

- `kanban-create-specs-then-push-to-archived`
  - 觸發：`$kanban-create-specs-then-push-to-archived`
  - 用途：從頭建立 Spec 與 Plans，兩次確認後自動推進到 Archived。
  - 問答：目的地路徑、需求敘述或討論
  - 停頓點：⏸️ Spec 確認 → ⏸️ Plans 確認 → 自動推進

- `kanban-create-plans-only`
  - 觸發：`$kanban-create-plans-only`
  - 用途：不經 Spec，直接建立 Plan 文件，完成後停止。
  - 問答：目的地路徑、任務內容摘要

- `kanban-create-plans-then-push-to-archived`
  - 觸發：`$kanban-create-plans-then-push-to-archived`
  - 用途：建立 Plans，確認後自動推進到 Archived。
  - 問答：目的地路徑、任務內容摘要
  - 停頓點：⏸️ Plans 確認 → 自動推進

- `kanban-create-testing-only`
  - 觸發：`$kanban-create-testing-only`
  - 用途：建立 Testing 文件並執行測試，完成後停止。
  - 問答：目的地路徑、測試內容摘要

- `kanban-create-testing-then-push-to-archived`
  - 觸發：`$kanban-create-testing-then-push-to-archived`
  - 用途：建立 Testing 文件，確認後自動推進到 Archived。
  - 問答：目的地路徑、測試內容摘要
  - 停頓點：⏸️ Testing 確認 → 自動推進

### 既有文件推進（Exist Flow）

- `kanban-exist-specs-push-to-archived`
  - 觸發：`$kanban-exist-specs-push-to-archived`
  - 用途：接收既有 Spec，拆解 Plans，確認後推進到 Archived。
  - 問答：來源 Spec 路徑
  - 停頓點：⏸️ Plans 建立確認 → 自動推進

- `kanban-exist-plans-push-to-archived`
  - 觸發：`$kanban-exist-plans-push-to-archived`
  - 用途：接收既有 Plans，驗證後自動推進到 Archived。
  - 問答：來源 Plans 路徑
  - 停頓點：⏸️ 驗證確認 → 自動推進

- `kanban-exist-testing-push-to-archived`
  - 觸發：`$kanban-exist-testing-push-to-archived`
  - 用途：接收既有 Testing，驗證後自動推進到 Archived。
  - 問答：來源 Testing 路徑
  - 停頓點：⏸️ 驗證確認 → 自動推進

### 歸檔與驗證

- `kanban-archive-only`
  - 觸發：`$kanban-archive-only`
  - 用途：確認 7-Done 文件全部完成後，執行歸檔搬移並建立 summary。
  - 問答：① 7-Done 路徑（強制驗收）→ ② 目的地路徑 → ③ 確認搬移

- `kanban-verify-completed-task`
  - 觸發：`$kanban-verify-completed-task`
  - 用途：針對已完成任務進行至少三次품質交叉驗證（需求對齊、文件覆蓋、測試執行）。
  - 問答：來源 Plans/Spec 路徑、重複次數（預設 3 次）

### 工具型

- `git-add-and-gen-commit-message`
  - 觸發：`$git-add-and-gen-commit-message`
  - 觸發（含路徑 + 語言）：`$git-add-and-gen-commit-message /path/to/folder zh`
  - 用途：針對本次修改的檔案，安全執行 `git add` 並自動產生完整 commit message。
  - 語言參數：支援 `zh`、`en`、`jp`（或中文、英文、日文等全名），預設英文。

- `git-smart-batch-commit`
  - 觸發：`$git-smart-batch-commit`
  - 觸發（含路徑）：`$git-smart-batch-commit /path/to/repo`
  - 用途：掃描 repo 中所有變動檔案，依功能自動細拆分組，為每組產生詳細英文 commit message，產出後強制暫停等待使用者確認，確認後才依序執行 git add + commit。絕對嚴格禁止自動 push。

## 維護原則

- `SKILL.md` 是流程規範主文件，每個 skill 資料夾都必須包含。
- 新增、調整、重新命名 skill 時，必須同步更新本 README 清單及 `kanban-skill-selector/SKILL.md`。
- 觸發字串與資料夾名稱必須保持一致。
