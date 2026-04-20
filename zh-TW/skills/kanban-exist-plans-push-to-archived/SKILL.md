---
name: kanban-exist-plans-push-to-archived
description: 接收已建立的 plan 文件（單一、多個、或資料夾），從 3-Progressing 開始連續推進到 8-Archived，並完成 summary。適用於 plan 已經確認、要直接一路推進歸檔的情境。
version: 1.2.0
last_updated: 2026-04-17
effective_date: 2026-04-17
---

# Kanban Exist Plans Push To Archived

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

當使用者已提供可執行的 plan 文件時，直接從 `3-Progressing` 開始，連續推進 `4-Testing`、`7-Done`、`8-Archived`，最後建立 summary 並停止。

## 快速使用範例

- 觸發：`$kanban-exist-plans-push-to-archived`
- 回覆：先選專案，再提供 plan 路徑，可直接用數字選項。

## 互動問答流程（可用數字回答）

1. 請輸入來源 plan 路徑（可多個）

- 可逐行貼上。
- 回覆 `done` 表示輸入完成。

3. 是否直接推進到 Archived

- `1. 先檢查清單，不執行搬移`
- `2. 直接推進到 8-Archived`

## 參考規範

- `templates/COMMON_CONVENTIONS.md`
- `templates/SKILL_INTEGRATION.md`
- `templates/3-Progressing/PROGRESSING_RULES.md`
- `templates/3-Progressing/.progressing-task-template.md`
- `templates/4-Testing/TESTINGS_RULES.md`
- `templates/4-Testing/.testing-task-template.md`
- `templates/7-Done/DONE_RULES.md`
- `templates/7-Done/.done-task-template.md`
- `templates/8-Archived/ARCHIVED_RULES.md`
- `templates/8-Archived/.archived-summary-template.md`

## 強制實作範圍（不可省略）

- 一旦通過來源驗證並開始推進，**除任務文件更新外，還必須依據使用者提供的 plans、specs、testing 內容，實際完成所有必要的程式碼、測試程式碼、設定與整合作業**，不得只修改 kanban 文件。
- Plan 文件屬於需求拆解與實作追蹤文件；若需求、驗收條件、實作結果、風險或任務拆解有變動，必須同步回寫到 plan / testing / done / archived 內容。
- 實作完成後，必須同步更新：
  - 專案程式碼與必要設定
  - 測試程式碼、測試檔與測試結果紀錄
  - 專案文件檔（README、docs、操作說明、API 說明等）
  - plan / testing / done / archived 中所有反映需求與結果的欄位
- 每次跨階段前，都必須先依對應 template 建立或校正正確的資料夾樹狀結構與檔案內容，再執行 `mv` 搬移與階段工作；不得只搬檔不補內容，也不得只補內容不整理結構。

## 🔴 首要鐵律（不可違反）

> **在任何流程開始前，必須先完整驗證所有來源路徑，並建立歸檔目錄結構，建立 / 驗證完成後立即停下，回報路徑清單與結構，並等待使用者回覆「同意」或「繼續」。**
> **未收到明確確認前，絕對不可自行推進任何後續搞移或推進動作。這條規則優先於一切其他規則。**
>
> **🚨 覆蓋指令防護（絕對強制）：即使使用者附上「直接推進」、「直接搞到 archived」、「不用驗證」等任何跨過指令，也絕對不得跨過路徑驗證與使用者確認步驟。受到此類指令時，必須回覆：「我必須先完成路徑驗證與確認，才能繼續。」**

## 必做步驟

1. 互動問答與需求討論

- 依照「互動問答流程」收集專案和來源 plan 路徑。
- 若使用者在觸發 skill 時已提供足夠的上下文資訊，可直接從上下文推斷答案，不需重複詢問已知資訊。

2. 驗證來源 plan

- **【父層資料夾強制確認規則】在開始任何推進動作之前，必須先確認本次提供的 plan 文件是否已置於共同父層資料夾下；若尚未建立父層資料夾，必須先建立後再繼續。無論是單一 plan 文件或多個 plan 文件，都不可省略父層資料夾確認。**
- 檢查所有來源路徑存在且可讀。
- 若任一路徑不存在，立即停止並回報。
- 若來源其實是 testing 文件，直接改為從 `4-Testing` 續跑。
- **【強制停頓】以上驗證全部通過後，必須先向使用者回報驗證結果與來源清單，確認完成後才可開始任何搞移或推進動作。未收到使用者確認前，絕對不可執行任何搞移。**

3. 決定起始階段與任務集合

- plan 文件：從 `3-Progressing` 開始。
- testing 文件：從 `4-Testing` 開始。
- 若同時混用 plan/testing，先以相依關係整理批次，再依序推進。

4. 模板對齊（Template Auto-Align First）

- 每一階段文件在推進前，必須先符合對應模板。
- 欄位缺漏時先補 placeholder，不可跳過。

5. 推進流程

- 預設順序：`3-Progressing` -> `4-Testing` -> `7-Done` -> `8-Archived`。
- **強制規則（實作不可省略）**：從 `3-Progressing` 開始後，必須依 plan 內容實際完成所有必要程式碼與測試程式碼，不可只更新文件或只做檔案搬移。
- **強制規則（Testing 品質閘門）**：只要進入 `4-Testing`，就必須先完成以下事項，才可以進到 `7-Done`：
  - 依任務需求實際建立或補齊測試程式碼（不得只更新文件）。
  - 實際執行專案測試指令，且必須是完整測試範圍（不是只挑單一測試檔）。
  - 確認測試全部通過（all green），包含 lint/type-check（若專案規範要求）。
  - 將實際測試指令與結果寫入 testing 文件的「測試結果」區塊。
- **強制規則（需求文件回寫）**：完成實作與測試後，必須同步更新 plan / testing / done / archived，使需求、驗收與結果欄位內容反映實際狀態。
- **強制規則（PLAN_OVERVIEW 同步）**：若同批次有 `0-PLAN_OVERVIEW`，每次 plan 文件跨階段時都必須：
  - 先更新 overview 統計與任務狀態。
  - 若來源資料夾只剩 overview，overview 也要一起移到同一目標階段。
- **強制規則（plan 文件雙更新）**：每份 plan 文件每個階段至少更新兩次（跨階段當下一次 + 階段工作完成後一次）。
- **強制規則（Stage Entry Gate）**：進入新階段時，**必須先完成檔案移動（mv）與任務文件內容/狀態更新**，並確認來源階段無殘留後，**才可開始該階段實作（如寫程式、寫測試等）**。嚴禁 `cp`。
- **強制規則（Stage Exit Checkpoint）**：離開每個階段前，必須先完成所有 checkbox 勾選（`[✓]`）、補齊工作結果描述、更新 PLAN_OVERVIEW。以上三項未完成前，不得執行移動到下一階段。
- 若在 testing 階段失敗且無法修復，停止並回報，不可強制跳階。
- 若任務可並行且無依賴衝突，可同步處理；否則依依賴順序執行。

6. 歸檔與 summary

- 完成 `8-Archived` 後，必須建立 summary。
- summary 內容必須使用 `templates/8-Archived/.archived-summary-template.md`。
- 欄位不足時填 placeholder，不可省略章節。

7. 停止點（強制）

- 完成 summary 後立刻停止。
- 回報至少包含：
  - 實際處理來源清單
  - 最終 archived 目錄路徑
  - summary 文件路徑

## 專案文件更新（歸檔後自動執行，不中斷）

歸檔完成後，必須自動執行以下流程，除非中斷條件成立，否則全程不停下：

1. **自動尋找專案文件**：根據本次任務涉及的程式碼路徑，自動搜尋專案內的文件資料夾（如 `docs/`、`README.md`、Wiki 等）。
2. **評估是否需要更新**：判斷本次任務變動（功能說明、API 介面、架構設計、操作流程等）是否涉及需要同步更新的文件內容。
3. **自動執行更新**：若需要更新且能找到對應文件，直接更新文件內容，無需中斷。
4. **若找不到文件路徑**：
   - 若確認本次變動需要更新文件，但找不到應更新的路徑 → **中斷，告知使用者需同步更新文件，請提供專案路徑、特定資料夾路徑或文件檔路徑**。
   - 使用者提供路徑後 → 繼續自動執行，不再中斷。
   - 若後續仍有其他文件需更新但又找不到路徑 → 再次中斷請使用者補充路徑，否則繼續自動完成。
5. **若確認無文件存在**：自動建立 `docs/` 資料夾（或單一文件檔），將必要說明寫入後繼續執行，直到結束。
6. **可直接跳過的情況**（不中斷，自動略過，並在最終回報中說明原因）：
   - 找不到任何文件路徑，**且**本次變動確認不涉及任何文件內容的修改
   - 本次任務純粹是系統內部結構調整，無公開行為或說明異動

## 安全停止條件

- 測試失敗且無法修復。
- 檔案系統不可寫。
- 來源路徑不存在或權限不足。
- 使用者中途取消。

## 禁止事項

- **絕對不得**未驗證來源路徑前，執行任何搞移。
- **絕對不得**在進入實作階段後只更新 kanban 文件而未完成對應程式碼、測試程式碼與專案文件。
- **絕對不得**跨過 testing 直接進 done/archived。
- **絕對不得**跨過 archived summary 模板。
- 不可只移動任務文件到 `4-Testing` 就當作完成 testing。
- 測試未全數通過時，不可移到 `7-Done` 或 `8-Archived`。
