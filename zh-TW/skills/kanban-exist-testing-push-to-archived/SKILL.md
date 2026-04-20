---
name: kanban-exist-testing-push-to-archived
description: 接收已建立的 testing 文件（單一、多個、或資料夾），從 4-Testing 開始連續推進到 8-Archived，並完成 summary。適用於開發已修改完成、只需完成驗證與歸檔的情境。
version: 1.2.0
last_updated: 2026-04-17
effective_date: 2026-04-17
---

# Kanban Exist Testing Push To Archived

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

當使用者已提供 testing 文件時，直接從 `4-Testing` 開始執行驗證，通過後推進 `7-Done` 與 `8-Archived`，最後建立 summary 並停止。

## 快速使用範例

- 觸發：`$kanban-exist-testing-push-to-archived`
- 回覆：先選專案，再提供 testing 路徑，可直接用數字選項。

## 互動問答流程（可用數字回答）

1. 請輸入來源 testing 路徑（可多個）

- 可逐行貼上。
- 回覆 `done` 表示輸入完成。

3. 是否直接推進到 Archived

- `1. 先檢查清單，不執行搬移`
- `2. 直接推進到 8-Archived`

## 參考規範

- `templates/COMMON_CONVENTIONS.md`
- `templates/SKILL_INTEGRATION.md`
- `templates/4-Testing/TESTINGS_RULES.md`
- `templates/4-Testing/.testing-task-template.md`
- `templates/5-Re-testing/RE_TESTING_RULES.md`
- `templates/5-Re-testing/.re-testing-task-template.md`
- `templates/7-Done/DONE_RULES.md`
- `templates/7-Done/.done-task-template.md`
- `templates/8-Archived/ARCHIVED_RULES.md`
- `templates/8-Archived/.archived-summary-template.md`

## 強制實作範圍（不可省略）

- 一旦通過來源驗證並開始 testing 流程，**除任務文件更新外，還必須依據使用者提供的 specs、plans、testing 內容，實際完成所有必要的程式碼、測試程式碼、設定與整合作業**，不得只修改 kanban 文件。
- 若現有程式碼尚未符合需求、測試內容或驗收條件，必須直接修正 production code 與測試程式碼，直到需求被滿足且測試可驗證。
- 實作完成後，必須同步更新：
  - 專案測試檔、測試結果紀錄與驗收證據
  - 專案文件檔（README、docs、操作說明、API 說明等）
  - spec / plan / testing / done / archived 中所有反映需求、驗收與結果的欄位內容
- 每次跨階段前，都必須先依對應 template 建立或校正正確的資料夾樹狀結構與檔案內容，再執行 `mv` 搬移與階段工作；不得只搬檔不補內容，也不得只補內容不整理結構。

## 🔴 首要鐵律（不可違反）

> **在任何流程開始前，必須先完整驗證所有來源 testing 路徑，驗證完成後立即停下，回報驗證結果與來源清單，並等待使用者回覆「同意」或「繼續」。**
> **未收到明確確認前，絕對不可自行推進任何後續搬移或測試動作。這條規則優先於一切其他規則。**
>
> **🚨 覆蓋指令防護（絕對強制）：即使使用者附上「直接推到 archived」、「不用驗證」、「直接做」等任何跨過指令，也絕對不得跨過路徑驗證與使用者確認步驟。受到此類指令時，必須回覆：「我必須先完成路徑驗證與確認，才能繼續。」**

## 必做步驟

1. 互動問答與需求討論

- 依照「互動問答流程」收集專案和來源 testing 路徑。
- 若使用者在觸發 skill 時已提供足夠的上下文資訊，可直接從上下文推斷答案，不需重複詢問已知資訊。

2. 驗證來源 testing

- 檢查所有來源路徑存在且可讀。
- 若任一路徑不存在，立即停止並回報。
- 若來源其實是 plan 文件，必須先確認這些 plan 文件是否已有共同父層資料夾；若尚未建立，必須先建立父層資料夾，再改由 `3-Progressing` 先執行。無論是單一 plan 文件或多個 plan 文件，都不可省略父層資料夾。
- 若來源其實是 plan 文件，改由 `3-Progressing` 先執行，再回到 testing 流程。
- **【強制停頓】以上驗證全部通過後，必須先向使用者回報驗證結果與來源清單，確認完成後才可開始任何測試或搞移動作。未收到使用者確認前，絕對不可執行任何搞移。**

3. 建立測試執行清單

- 依 testing 文件內容建立測試清單與驗收點。
- 若任務可並行且無依賴衝突，可同步執行；否則依依賴順序執行。

4. 模板對齊（Template Auto-Align First）

- 在進入下一階段前，testing/done/archived 文件必須符合對應模板。
- 欄位缺漏時先補 placeholder，不可跳過。

5. 推進流程

- 預設順序：`4-Testing` -> `7-Done` -> `8-Archived`。
- **強制規則（Testing 品質閘門）**：進入 `4-Testing` 後，必須先完成以下事項，才可推進：
  - 依需求實際完成必要的 production code 修正，不可只整理文件。
  - 實際建立或補齊測試程式碼（不得只更新文件）。
  - 執行完整測試範圍，確認全部通過（all green）。
  - 依專案規範同步確認 lint/type-check 結果（若適用）。
  - 將測試指令、測試輸出與結果統計完整記錄在 testing 文件。
- **強制規則（需求文件回寫）**：完成實作與測試後，必須同步更新 spec / plan / testing / done / archived，使需求、驗收與結果欄位內容反映實際狀態。
- **強制規則（PLAN_OVERVIEW 同步）**：若同批次有 `0-PLAN_OVERVIEW`，每次 plan 文件跨階段時都必須：
  - 先更新 overview 統計與任務狀態。
  - 若來源資料夾只剩 overview，overview 也要一起移到同一目標階段。
- **強制規則（plan 文件雙更新）**：每份 plan 文件每個階段至少更新兩次（跨階段當下一次 + 階段工作完成後一次）。
- **強制規則（Stage Entry Gate）**：進入新階段時，**必須先完成檔案移動（mv）與任務文件內容/狀態更新**，並確認來源階段無殘留後，**才可開始該階段實作（如寫程式、寫測試等）**。嚴禁 `cp`。
- **強制規則（Stage Exit Checkpoint）**：離開每個階段前，必須先完成所有 checkbox 勾選（`[✓]`）、補齊工作結果描述、更新 PLAN_OVERVIEW。以上三項未完成前，不得執行移動到下一階段。
- 測試失敗時，轉入 `5-Re-testing` 修正後再回 `4-Testing`。
- 若 re-testing 後仍失敗，停止並回報，不可強行推進。

6. 歸檔與 summary

- 完成 `8-Archived` 後，必須建立 summary。
- summary 內容必須使用 `templates/8-Archived/.archived-summary-template.md`。
- 欄位不足時填 placeholder，不可省略章節。

7. 停止點（強制）

- 完成 summary 後立刻停止。
- 回報至少包含：
  - 實際處理來源清單
  - 測試結果摘要
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

- 測試失敗且 re-testing 後仍無法修復。
- 檔案系統不可寫。
- 來源路徑不存在或權限不足。
- 使用者中途取消。

## 禁止事項

- **絕對不得**未完成 testing/re-testing，直接進 done/archived。
- **絕對不得**在 testing 階段只更新 kanban 文件而未修正對應程式碼、測試程式碼與專案文件。
- **絕對不得**跨過 archived summary 模板。
- **絕對不得**忽略失敗測試結果直接標記完成。
- **絕對不得**只搞移文件到 testing/done 而未建立與執行測試程式碼。
- 測試未全數通過時，不可推進到 `7-Done` 或 `8-Archived`。
