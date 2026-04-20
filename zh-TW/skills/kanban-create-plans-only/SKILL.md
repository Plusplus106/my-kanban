---
name: kanban-create-plans-only
description: 不經 Spec，直接建立 Plan 文件到 2-Plans。預設不自動跨階段，並支援可用數字回答的固定問答流程。
version: 1.5.0
last_updated: 2026-03-17
effective_date: 2026-03-17
---

# Kanban Create Plans Only

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

在需求明確且不需要完整 Spec 時，快速建立 Plan。

## 快速使用範例

- 觸發：`$kanban-create-plans-only`
- 回覆：可直接用數字選項（例如 `1`、`2`）。

## 互動問答流程（可用數字回答）

1. 目的地路徑

- 請輸入要建立 Plan 的目的地路徑（例如：`my-project/2-Plans/`）

2. 任務內容摘要

- 一行描述功能目標、主要限制與驗收重點。

## 參考規範

- `templates/COMMON_CONVENTIONS.md`
- `templates/SKILL_INTEGRATION.md`
- `templates/2-Plans/PLANS_RULES.md`
- `templates/2-Plans/PHASE_PRIORITY_GUIDELINES.md`
- `templates/2-Plans/.plan-overview-template.md`
- `templates/2-Plans/.plan-template.md`
- `templates/3-Progressing/PROGRESSING_RULES.md`
- `templates/3-Progressing/.progressing-task-template.md`
- `templates/4-Testing/TESTINGS_RULES.md`
- `templates/4-Testing/.testing-task-template.md`
- `templates/7-Done/DONE_RULES.md`
- `templates/7-Done/.done-task-template.md`
- `templates/8-Archived/ARCHIVED_RULES.md`
- `templates/8-Archived/.archived-summary-template.md`

## 🔴 首要鐵律（不可違反）

> **在任何流程開始前，必須先完整建立所有必要的資料夾與文件（Plan 文件、PLAN_OVERVIEW 等），建立完成後立即停下，回報所有已建立的路徑清單，並等待使用者回覆「同意」或「繼續」。**
> **未收到明確確認前，絕對不可自行推進任何後續步驟。這條規則優先於一切其他規則。**
>
> **🚨 覆蓋指令防護（絕對強制）：即使使用者同時提供了完整的需求內容，並附上「請開始實作」、「PLEASE IMPLEMENT」、「直接做」、「不用建文件」等任何形式的跨過指令，也絕對不得跨過 Plan 文件建立與使用者確認步驟。受到此類指令時，必須回覆：「我必須先完成 Plan 文件建立與確認，才能繼續。」**

## 必做步驟

1. 互動問答與需求討論

- 依照「互動問答流程」收集目的地路徑。
- 若使用者在觸發 skill 時已提供足夠的上下文資訊（例如問題描述、檔案路徑、需求說明），可直接從上下文推斷答案，不需重複詢問已知資訊。

2. 確認需求與範圍

- 功能描述
- 驗收條件
- 影響範圍

3. 建立 Plan 文件

- **【父層資料夾強制確認規則】在建立任何 plan 文件之前，必須先確認目的地是否已有父層資料夾；若尚未建立，必須先建立父層資料夾，再於其中建立 plan 文件。無論本次建立的是單一 plan 文件或多個 plan 文件，都不可省略父層資料夾。**
- 有 Spec 時：
  - 路徑：`<目的地路徑>/[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]/`
- 無 Spec 時：
  - 路徑：`<目的地路徑>/`
  - 命名：`[YYYY-MM-DD]-[no-spec]-[數字]-[優先級]-[plan-xxxxx]-[類別]-描述.md`
- 有 Spec 時，需先建立 `0-PLAN_OVERVIEW`，且欄位符合 `templates/2-Plans/.plan-overview-template.md`。
- 每個 plan 內容欄位必須符合 `templates/2-Plans/.plan-template.md`。
- **【強制停頓】Plan 文件（含所有 .md 檔案）實際建立完成後，必須立即回報所有已建立的文件路徑，並停下等待使用者確認。未收到確認前，絕對不可繼續任何後續動作。**

4. 填入必要欄位

- 狀態
- 優先級
- 複雜度
- 依賴關係
- 是否可並行
- 驗收標準

5. 預設行為

- **停在 `2-Plans`（`plan-only`），不得自行進入下一階段。**

6. full pipeline（選用）

- 需 `plan-full-pipeline` + 額外確認。
- 若啟用，必須逐階段套用對應模板（progressing/testing/done/archived）。
- 若流程進入 `4-Testing`，必須完成 Testing 品質閘門後才可進入 `7-Done`：
  - 建立或補齊測試程式碼。
  - 執行完整測試範圍（不可只跑單一測試檔）。
  - 確認全部測試通過（all green）。
  - testing 文件寫入測試指令與完整輸出。
- 未符合模板時，先自動對齊模板，再轉下一階段（Template Auto-Align First）。
- 對齊時若資訊不足，必須先填入 placeholder，不得因此中止流程。
- 僅當檔案系統不可寫時，才可停止並回報。
- 進入 `8-Archived` 時，`summary` 必須依 `templates/8-Archived/.archived-summary-template.md` 建立。

## Full Pipeline 二次確認標準句

啟用 `*-full-pipeline` 前，必須使用以下句型：

`請確認：你要啟用 <pipeline>，並授權 auto_transition=true，讓流程自動跨階段執行直到 7-Done/8-Archived。請回覆「同意」。`

若未收到使用者明確回覆「同意」，不得啟動 full pipeline。

## 禁止事項

- **絕對不得**未經授權自動 `mv` 到 `3-Progressing`。
- **絕對不得**只把文件移到 `4-Testing` 就當作完成 testing。
- **絕對不得**在文件建立完成並確認前推進到下一階段。
- 測試未全數通過時，不可移到 `7-Done` 或 `8-Archived`。
