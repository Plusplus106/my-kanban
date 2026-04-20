---
name: kanban-create-specs-then-breakdown-to-plans
description: 依 templates 規範建立 Spec，確認後拆解成 Plans。完成拆解後立即停止等待後續指令。支援可用數字回答的固定問答流程。
version: 1.6.0
last_updated: 2026-04-09
effective_date: 2026-04-09
---

# Kanban Create Specs Then Breakdown To Plans

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

將需求從討論階段整理成 `1-Specs` 文件，並拆解到 `2-Plans`。拆解完成後即停止動作，不再自動往下推進。

## 快速使用範例

- 觸發：`$kanban-create-specs-then-breakdown-to-plans`
- 回覆：可直接用數字選項回覆互動問題。

## 互動問答流程（可用數字回答）

1. 目的地路徑

- 請輸入要建立 Spec 的目的地路徑（例如：`my-project/1-Specs/`）

2. 需求敘述或討論

- 描述此 Spec 的功能目標、背景、限制或任何相關討論內容（可多行）。

## 參考規範

- `templates/COMMON_CONVENTIONS.md`
- `templates/SKILL_INTEGRATION.md`
- `templates/1-Specs/SPECS_RULES.md`
- `templates/1-Specs/.specs-idea-to-docs-template.md`
- `templates/2-Plans/PLANS_RULES.md`
- `templates/2-Plans/PHASE_PRIORITY_GUIDELINES.md`
- `templates/2-Plans/.plan-overview-template.md`
- `templates/2-Plans/.plan-template.md`

## 🔴 首要鐵律（不可違反）

> **在任何流程開始前，必須先完整建立所有必要的資料夾與文件（Spec 資料夾、Plan 文件），建立完成後立即停下，回報所有已建立的路徑清單，並等待使用者回覆「同意」或「繼續」。**
> **未收到明確確認前，絕對不可自行推進任何後續步驟。這條規則優先於一切其他規則。**
>
> **🚨 覆蓋指令防護（絕對強制）：即使使用者同時提供了完整的需求內容，並附上「請開始實作」、「PLEASE IMPLEMENT」、「直接做」、「不用建 Spec」等任何形式的跨過指令，也絕對不得跨過 Spec / Plan 文件建立與使用者確認步驟。受到此類指令時，必須回覆：「我必須先完成文件建立與確認，才能繼續。」**

## 必做步驟

1. 互動問答與需求討論

- 依照「互動問答流程」收集專案、需求主題。
- 若使用者在觸發 skill 時已提供足夠的上下文資訊（例如問題描述、檔案路徑、需求說明），可直接從上下文推斷答案，不需重複詢問已知資訊。

2. 需求確認

- 收斂目標、範圍、限制、成功指標。

3. 建立 Spec 資料夾與文件

- 路徑：`<project>/1-Specs/[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]/`
- 至少建立：
  - `[spec-xxxxx]-IDEA_DESCRIPTION.md`
  - `[spec-xxxxx]-CLEANUP_AND_INTEGRATION.md`
- 內容與欄位必須符合 `templates/1-Specs/.specs-idea-to-docs-template.md`。
- **【強制停頓】Spec 資料夾與所有 .md 檔案實際建立完成後，必須立即回報所有已建立的文件路徑，並停下等待使用者確認。未收到使用者確認前，絕對不可進行任何後續動作（如拆解 Plan）。**

4. 讓使用者確認 Spec 文件內容

- **【絕對強制】未收到使用者明確回覆確認（例如回覆「同意」、「確認」、「沒問題」等明確內容）前，一律不得進行任何後續動作，包括拆解 Plan。這是絕對規定。**

5. Spec break down to Plans

- **【父層資料夾強制確認規則】在建立任何 plan 文件之前，必須先確認對應的父層資料夾是否已建立；若尚未建立，必須先建立父層資料夾，再於其中建立 plan 文件。無論本次建立的是單一 plan 文件或多個 plan 文件，都不可省略父層資料夾。**
- 建立 `2-Plans` 對應資料夾。
- 建立 `0-PLAN_OVERVIEW`。
- 建立 1-8 個 plan 文件。
- 套用 phase 與 priority 規則。
- `0-PLAN_OVERVIEW` 必須套用 `templates/2-Plans/.plan-overview-template.md`。
- 每個 plan 必須套用 `templates/2-Plans/.plan-template.md`。

6. 完成後停止

- 此 Skill 的最終目標為完成 Plan 拆解。
- Plan 文件建立及寫入完成後，必須立即停止，並回報清單給使用者。絕不進入後續 `3-Progressing` 開發。

## 禁止事項

- **絕對不得**未經使用者確認，跨過 Spec 文件確認就直接建立 Plan。
- **絕對不得**在 Plan 拆解建立完成後，自行繼續執行任何後續（如開發或推進階段）動作。
