# Kanban 自動化整合規範

> **📌 本文件定義自動化工具整合設定**
>
> 適用範圍：workflow skill（目前）或未來替代自動化工具（之後）

**Version:** 1.3.0  
**Last Updated:** 2026-03-09  
**Effective Date:** 2026-03-09

---

## 路徑解讀規則（語系可配置）

本文件中的路徑（例如 `templates/...`、`scripts/...`、`promps/...`、`skills/...`）皆以「目前語系內容根目錄」為相對基準。

- 不強制綁定 repo 根目錄固定路徑。
- 可直接套用到不同語系版本（如 `zh-TW/`、`ja/`、`en/`）。

---

## 目的

本文件集中定義工具特定流程設定，避免把可替換邏輯寫死在 `COMMON_CONVENTIONS.md`。

## 適用模型

- 模式：`mode`（`spec` / `plan` / `testing`）
- 流程：`pipeline`
- 自動轉階段：`auto_transition`

## 執行模式預設

- `spec`：預設 `spec-to-plan`（`auto_transition=false`）。若要完整流程，必須明確指定 `spec-full-pipeline` 並再確認一次。
- `plan`：預設 `plan-only`。若要一路自動執行到結束，必須明確指定 `plan-full-pipeline` 並額外確認一次。
- `testing`：預設 `testing-only`。若要一路自動執行到結束，必須明確指定 `testing-full-pipeline` 並額外確認一次。

## mode / pipeline / auto_transition 組合句型

- `mode=spec`、`pipeline=spec-to-plan`、`auto_transition=false`：建立 Spec，確認後拆成 Plan，停在 Plan，不自動往下階段。
- `mode=spec`、`pipeline=spec-full-pipeline`、`auto_transition=true`：從 Spec 開始，自動執行到 Progressing、Testing，通過 Testing 品質閘門後才可移到 7-Done/8-Archived。
- `mode=plan`、`pipeline=plan-only`、`auto_transition=false`：只建立並處理 Plan，完成後不自動轉到 Testing。
- `mode=plan`、`pipeline=plan-full-pipeline`、`auto_transition=true`：從 Plan 開始，自動進入實作、測試與文件更新，通過 Testing 品質閘門後才可移到 7-Done/8-Archived。
- `mode=testing`、`pipeline=testing-only`、`auto_transition=false`：只建立與執行測試任務，不自動回推其他階段。
- `mode=testing`、`pipeline=testing-full-pipeline`、`auto_transition=true`：從 Testing 開始，自動完成測試、修正與文件更新，通過 Testing 品質閘門後才可移到 7-Done/8-Archived。

## 參數決策表（建議固定使用）

| mode      | pipeline                | auto_transition | 是否允許自動跨階段 | 行為摘要                                 |
| --------- | ----------------------- | --------------- | ------------------ | ---------------------------------------- |
| `spec`    | `spec-to-plan`          | `false`         | 否                 | 建立 Spec，確認後拆 Plan，停在 `2-Plans` |
| `spec`    | `spec-full-pipeline`    | `true`          | 是（需二次確認）   | 從 Spec 自動推進到 7-Done/8-Archived     |
| `plan`    | `plan-only`             | `false`         | 否                 | 建立/執行 Plan，停在當前階段             |
| `plan`    | `plan-full-pipeline`    | `true`          | 是（需二次確認）   | 從 Plan 自動推進到 7-Done/8-Archived     |
| `testing` | `testing-only`          | `false`         | 否                 | 僅建立與執行測試，不推進其他階段         |
| `testing` | `testing-full-pipeline` | `true`          | 是（需二次確認）   | 從 Testing 自動推進到 7-Done/8-Archived  |

## Testing 品質閘門（強制）

只要任何流程進入 `4-Testing`，必須在推進 `7-Done` 前完成以下條件：

1. 已建立或補齊測試程式碼（不得只更新文件）。
2. 已執行完整測試範圍（不得只跑單一測試檔）。
3. 全部測試通過（all green），且 lint/type-check（若專案要求）通過。
4. testing 文件已記錄測試指令、完整輸出、通過/失敗統計。

若任一條件未滿足，必須停在 `4-Testing` 或回到 `5-Re-testing`，禁止移動到 `7-Done` 與 `8-Archived`。
未通過 Testing 品質閘門時，不可推進到 `7-Done` 或 `8-Archived`。

## 互斥與預設規則

- 若只給 `mode` 未給 `pipeline`，套用預設：
  - `spec` -> `spec-to-plan`
  - `plan` -> `plan-only`
  - `testing` -> `testing-only`
- `spec-to-plan` 必須搭配 `auto_transition=false`。
- 任何 `*-full-pipeline` 必須搭配 `auto_transition=true`。
- 若組合不合法（例如 `plan-only + auto_transition=true`），視為設定衝突，必須停止並請使用者重新確認。
- 若 `auto_transition=true` 但未完成「二次確認」，一律降級為對應的 `*-only` 或 `spec-to-plan`。

## Full Pipeline 二次確認標準句

啟用 `*-full-pipeline` 前，必須逐字確認以下句型之一：

- `請確認：你要啟用 <pipeline>，並授權 auto_transition=true，讓流程自動跨階段執行直到 7-Done/8-Archived。請回覆「同意」。`
- 若使用者未明確回覆「同意」，不得啟動 full pipeline。

## Preflight Checklist（執行前檢查）

開始執行前，至少完成以下檢查：

1. 專案目標正確（`ai-fridge-app` / `api-gateway` / `ai-fridge-app-be`）。
2. `mode`、`pipeline`、`auto_transition` 組合合法且無衝突。
3. 目標資料夾存在且可寫入（`1-Specs`、`2-Plans`、`4-Testing` 等）。
4. 必要規範檔可讀取（`COMMON_CONVENTIONS.md` 與對應 RULES 檔）。
5. 測試命令可執行，且執行環境可用（依專案實際工具）。
6. 若為 full pipeline，已完成二次確認且有明確授權。
7. 若會進入 `4-Testing`，已確認可執行完整測試並記錄輸出證據。

## Template Binding Matrix（強制）

所有模式都必須套用對應階段的模板與規則；未套用即視為流程不合法。

| 階段            | 必讀規則                                                                             | 必用模板                                                                                    |
| --------------- | ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- |
| `1-Specs`       | `templates/1-Specs/SPECS_RULES.md`                                                   | `templates/1-Specs/.specs-idea-to-docs-template.md`                                         |
| `2-Plans`       | `templates/2-Plans/PLANS_RULES.md`、`templates/2-Plans/PHASE_PRIORITY_GUIDELINES.md` | `templates/2-Plans/.plan-overview-template.md`、`templates/2-Plans/.plan-template.md`       |
| `3-Progressing` | `templates/3-Progressing/PROGRESSING_RULES.md`                                       | `templates/3-Progressing/.progressing-task-template.md`                                     |
| `4-Testing`     | `templates/4-Testing/TESTINGS_RULES.md`                                              | `templates/4-Testing/.testing-task-template.md`                                             |
| `5-Re-testing`  | `templates/5-Re-testing/RE_TESTING_RULES.md`                                         | `templates/5-Re-testing/.re-testing-task-template.md`                                       |
| `7-Done`        | `templates/7-Done/DONE_RULES.md`                                                     | `templates/7-Done/.done-task-template.md`                                                   |
| `8-Archived`    | `templates/8-Archived/ARCHIVED_RULES.md`                                             | `templates/8-Archived/.archived-summary-template.md`，並整理 `1-Specs/`、`done-plans/` 結構 |

## Stage Transition Gate（強制）

每次跨階段前都要先檢查：

1. 本階段輸出文件是否符合對應模板欄位與命名。
2. 下一階段需要的輸入文件是否存在且可讀。
3. 若任一項不符合，必須先自動對齊模板（補欄位、修命名、修結構）後再繼續。
4. 對齊時若資訊不足，必須先填入 placeholder，不得因此中止流程。
5. 僅當檔案系統不可寫（權限、唯讀、檔案鎖定）時，才可停止流程並回報缺口。
6. 若 Testing 品質閘門未通過，必須停止推進至 `7-Done/8-Archived`。
7. 若同批次有 `0-PLAN_OVERVIEW`，每次有 plan 文件跨階段移動後，必須同步更新 overview 內容（狀態、統計、最後更新）。
8. 若來源資料夾中除了 `0-PLAN_OVERVIEW` 外已無同批次文件，`0-PLAN_OVERVIEW` 必須跟著移到同一目標階段資料夾，並更新內文。
9. 每一份 plan 文件在每個階段至少要完成兩次內容更新：跨階段當下更新一次、該階段工作完成後再更新一次。
10. 同批次一次推進只允許單一目標階段；不可在同一步驟把同批次文件拆分到多個階段。
11. 🚪 **Stage Entry Gate（強制）**：每次跨階段移動後，必須確認來源階段中該批次文件已不存在（已被 `mv` 移走，不可用 `cp`）。若來源資料夾已無同批次文件，刪除空資料夾。
12. ✅ **Stage Exit Checkpoint（強制）**：離開每個階段前，必須先完成所有 checkbox 勾選、補齊工作結果描述、更新 PLAN_OVERVIEW。以上三項未完成前，不得執行移動。

**Template Auto-Align First：** 未符合模板時，先修正到符合模板，再進入下一階段；不得因格式對齊而中止。

## 失敗處理與回復流程

若流程失敗，依序執行：

1. 立即停止自動流程，保留現況，不做額外移動。
2. 回報失敗點（步驟、檔案、命令、錯誤摘要）。
3. 說明是否已寫入部分內容（避免使用者誤判為全失敗）。
4. 提供最小回復方案（例如：回到 `plan-only`、僅補測試、先修環境）。
5. 取得使用者確認後再繼續，不得自行重跑 full pipeline。

## Skill 淘汰或替換處理

若現行 skill 被淘汰：

1. 保留 `COMMON_CONVENTIONS.md` 不動（只含共通原則）。
2. 更新本文件的流程參數與問答規則，改為新工具對應格式。
3. 逐步替換 `~/.codex/skills` 內 skill，或改接新自動化入口。
4. 若短期無可替代工具，直接回到手動模式，不中斷既有規範。
