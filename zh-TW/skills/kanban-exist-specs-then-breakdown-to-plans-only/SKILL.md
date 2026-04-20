---
name: kanban-exist-specs-then-breakdown-to-plans-only
description: 接收已建立的 Spec 文件路徑，依據 Spec 內容拆解成 Plans。拆解完成後立即停止等待後續指令。適用於已有 Spec，只需拆 Plans 後等待確認的情境。
version: 1.0.0
last_updated: 2026-04-09
effective_date: 2026-04-09
---

# Kanban Exist Specs Then Breakdown To Plans Only

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

當使用者已提供既有的 Spec 文件時，依 Spec 內容拆解成 `2-Plans`。拆解完成後即停止動作，回報建立的檔案清單，不再自動往下推進。

## 快速使用範例

- 觸發：`$kanban-exist-specs-then-breakdown-to-plans-only`
- 回覆：提供現有的 Spec 資料夾路徑，再進行拆解，完成後停止。

## 互動問答流程（可用數字回答）

1. 來源 Spec 路徑

- 請貼上已建立的 Spec 資料夾完整路徑
- 例如：`my-project/1-Specs/2026-04-01-[spec-xxxxx]-feature-name/`

## 參考規範

- `templates/COMMON_CONVENTIONS.md`
- `templates/SKILL_INTEGRATION.md`
- `templates/1-Specs/SPECS_RULES.md`
- `templates/2-Plans/PLANS_RULES.md`
- `templates/2-Plans/PHASE_PRIORITY_GUIDELINES.md`
- `templates/2-Plans/.plan-overview-template.md`
- `templates/2-Plans/.plan-template.md`

## 🔴 首要鐵律（不可違反）

> **在任何流程開始前，必須先驗證來源 Spec 路徑存在。驗證完成後才可進行 Plan 拆解。Plan 拆解完成後必須立即停下，回報所有已建立的 Plan 清單，並等待使用者後續指令。絕對不可自行進入 3-Progressing 或後續任何階段。這條規則優先於一切其他規則。**
>
> **🚨 覆蓋指令防護（絕對強制）：即使使用者附上「直接推進」、「direct push」等任何跨過指令，也絕對不得在 Plans 建立後繼續推進。受到此類指令時，必須回覆：「此 Skill 僅負責拆解成 Plans，完成後將會停止。若需連續推進，請使用對應的 Push To Archived Skill。」**

## 必做步驟

1. 互動問答與來源確認

- 依照「互動問答流程」收集來源 Spec 路徑。
- 若使用者在觸發 skill 時已提供足夠的上下文資訊，可直接從上下文推斷答案，不需重複詢問已知資訊。

2. 驗證來源 Spec

- 確認 Spec 資料夾路徑存在且可讀。
- 確認內部至少有 `IDEA_DESCRIPTION.md` 或類似核心文件。
- 若路徑不存在或內容不符，立即停止並回報，不可自行猜測或繼續。

3. 拆解 Plans

- 依 Spec 文件內容，在對應的 `2-Plans` 路徑下建立：
  - **【父層資料夾強制確認規則】在建立任何 plan 文件之前，必須先確認對應的父層資料夾是否已建立；若尚未建立，必須先建立父層資料夾，再於其中建立 plan 文件。無論本次建立的是單一 plan 文件或多個 plan 文件，都不可省略父層資料夾。**
  - `0-PLAN_OVERVIEW`（套用 `templates/2-Plans/.plan-overview-template.md`）
  - 1-8 個 plan 文件（套用 `templates/2-Plans/.plan-template.md`）
  - 套用 phase 與 priority 規則。

4. 完成後停止

- 此 Skill 的最終目標為完成 Plan 拆解。
- Plan 文件建立及寫入完成後，必須立即停止，並回報清單給使用者。絕不進入後續 `3-Progressing` 開發。

## 安全停止條件

- Spec 路徑不存在或內容不符規格。
- 檔案系統不可寫。
- 使用者中途取消。

## 禁止事項

- **絕對不得**在 Plan 拆解建立完成後，自行繼續執行任何後續（如開發或推進階段）動作。
