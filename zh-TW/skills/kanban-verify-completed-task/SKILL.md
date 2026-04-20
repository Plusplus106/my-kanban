---
name: kanban-verify-completed-task
description: 針對由其他 AI 完結的任務，進行至少三次以上的重複檢查。嚴格驗證所有內容是否符合原始需求、測試檔與文件是否已完整更新，並確保所有測試檔已通過執行測試。適用於任務交接或交付前的品質把關。
version: 1.1.0
last_updated: 2026-04-17
effective_date: 2026-04-17
---

# Kanban Verify Completed Task

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

本 skill 的主要目的是作為「品質防線 (Quality Gate)」。當一個任務已由其他 AI（或開發者）標示完成時，透過本 skill 進行至少三次深度、交叉比對的重複檢查，確保：

1. 實作內容完全符合原始需求與規格。
2. 相關文件 (Spec, Plan, README 等) 已正確同步更新。
3. 測試檔已針對修改或新增的功能對應更新或建立。
4. 所有牽涉到的測試皆已實際執行且顯示通過 (All green)。

## 快速使用範例

- 觸發：`$kanban-verify-completed-task`
- 回覆：提供要檢查的任務路徑（如：特定目錄、相關的文件路徑、或 PR 連結等）。

## 互動問答流程（可用數字回答）

1. 來源 Plans / Spec 文件或資料夾路徑

- 請貼上要驗證的來源路徑（可多行，輸入 done 結束）。
- 可以是 plan 文件、spec 資料夾、完整的 task 資料夾，或 8-Archived 下的歸檔目錄。
- 例如：`my-project/8-Archived/2026-04-01-[spec-xxxxx]-feature/`

2. 重複檢查次數

- 預設會進行 **3 次**獨立交叉檢查，是否要更改次數？
- 直接按 Enter 或回覆 `3` 使用預設值，或輸入其他數字（最少 3 次）。

## 🔴 首要鐵律（不可違反）

> **強制執行至少三次的獨立檢查迴圈，每次檢查必須著重不同面向（例如：第一次核對規格與程式碼、第二次核對文件與註解、第三次驗證測試檔與執行結果）。**
> **只要在任一次檢查中發現有問題或測試失敗，必須立即將問題條列出來，並詢問使用者是否開始解決這些問題。如果使用者同意，則開始處理，處理完成後，自動開始跑下一輪檢查，一直反覆到所有輪數都完成，且沒有任何問題。**
> **所有 verify 輪數完成且確認無缺失後，無論來源目前位於 `1-Specs`、`2-Plans`、`3-Progressing`、`4-Testing`、`5-Re-testing`、`7-Done` 或 `8-Archived`，都必須再執行一次 Archived 收尾流程；不得只停在總結報告，也不得把是否歸檔當成可省略選項。**

## 必做步驟

1. 資訊收集與準備

- 確認要檢查的來源路徑。
- 讀取其對應的原始需求/Spec 文件。
- 收集所有在本次任務中被修改或建立的原始碼、測試檔、與文件清單。

2. 第一回合：需求與規格比對檢查 (Round 1: Requirement Alignment)

- 將修改後的程式碼邏輯與 Spec/Plan 上的驗收標準 (Acceptance Criteria) 逐一比對。
- 確認所有列出的需求都已被滿足，沒有遺漏功能，也沒有多做不在範圍內的功能。

3. 第二回合：文件與測試範圍檢查 (Round 2: Doc & Test Coverage)

- 檢查關聯任務文件狀態及勾選項目是否已詳實填寫。
- 檢查測試檔 (`.test.ts`, `.spec.ts` 等) 內容：確認其涵蓋了正向路徑 (Happy path) 以及預期的錯誤情境 (Edge cases)。
- 確認修改到的功能如有架構異動，對應的 README 或教學文件是否有同步更新。

4. 第三回合：執行測試與結果驗證 (Round 3: Test Execution & Validation)

- 實際執行相關的測試指令（需涵蓋修改過的元件、API 或是整個 test suite）。
- 若專案層級還有 lint 或 type-check 指令，一併執行確保語法正確。
- 確認終端機輸出結果呈現為完全通過 (All tests passed)。
- 若沒有發生任何錯誤，在相關任務文件內補上測試通過的截錄記錄。

5. Archived 收尾流程（Verify 完成後強制執行）

- 在所有 verify 輪數通過後，必須先判定來源路徑目前所處的階段，並依下列規則立即接續對應的 archived 流程，不可跳過：
  - 來源在 `1-Specs/`：執行 `kanban-exist-specs-push-to-archived`
  - 來源在 `2-Plans/` 或 `3-Progressing/`：執行 `kanban-exist-plans-push-to-archived`
  - 來源在 `4-Testing/` 或 `5-Re-testing/`：執行 `kanban-exist-testing-push-to-archived`
  - 來源在 `7-Done/`：執行 `kanban-archive-only`
  - 來源已在 `8-Archived/`：仍必須再次比對 `templates/8-Archived/ARCHIVED_RULES.md`、summary 模板、來源清理結果與 archived 目錄結構；若任一項不符，立即補齊到完全符合 archived 規範為止
- 若同一批來源橫跨多個階段，必須先依相依性整理批次，再從最前面的未完成階段開始推進到 `8-Archived`，不可只處理其中一部分。
- Archived 收尾流程完成後，必須再次確認：
  - 最終權威文件只存在於 `8-Archived/`
  - `summary` 已存在且內容符合模板
  - 中間階段無殘留同批次文件或空資料夾
  - verify 過程補上的測試結果、文件修正、checkbox 狀態都已反映到 archived 最終文件

6. 總結報告與後續處理 (Final Report & Next Steps)

- 在所有輪數檢查全數通過，且沒有任何問題後，產出一份總結報告。
- 條列這幾次檢查中所確認的重點（例：已檢查規格、已確認 3 個測試檔涵蓋範圍、已執行測試共 15 個 test cases 皆通過）。
- 報告中必須明確列出本次 verify 完成後，實際接續執行的 archived 流程名稱、最終 archived 目錄路徑、summary 文件路徑，以及已清除的中間階段殘留路徑。
- 只有在 archived 收尾流程也完成後，整個 verify 才算真正結束。
- verify + archived 全部完成後，接著詢問使用者：「是否開始跑 git-add-and-gen-commit-message 的 skill？」
- 若使用者同意，就開始執行該 git skill。

## 安全停止條件與問題處理流程

- 每一輪的檢查中，如果發現有問題、缺失或 bug，立即列出問題清單，並詢問使用者是否開始解決這些問題。
- 若使用者同意，則自動開始修復程式碼或文件。修復完成後，自動開始跑下一輪檢查（重新跑流程確保無遺漏），反覆此流程直到所有輪數完成且零缺失。
- 若 verify 已通過，但 Archived 收尾流程中發現結構、summary、搬移位置或來源清理仍不符合規範，視為 verify 尚未真正完成；必須先補齊 archived 狀態，再回到最終報告。
- 只有在使用者明確選擇不處理，或是發現即使經過反覆修復仍無法解決的嚴重錯誤時，才真正停止並交由使用者了解狀況。

## 禁止事項

- **絕對不得**只做一次檢查就宣稱「檢查了三次完成」。必須在工作過程 (日誌或思考流程) 中實質展現三次獨立的檢查。
- **絕對不得**在未實際執行測試 (`yarn test` 或相似指令) 的情況下，假定或虛構測試結果通過。
- **絕對不得**自行幫使用者掩蓋缺少的情境，必須將發現的缺漏回報給使用者。
- **絕對不得**在 verify 完成後只提供總結而未再執行 archived 收尾流程。
- **絕對不得**在來源仍位於 `1-Specs`、`2-Plans`、`3-Progressing`、`4-Testing`、`5-Re-testing` 或 `7-Done` 時，宣稱任務已完成 archived 狀態。
