---
name: kanban-create-specs-then-breakdown-to-plans
description: 依 templates 規範建立 Spec，確認後拆解成 Plans。完成拆解後立即停止等待後續指令。支援可用數字回答的固定問答流程。
version: 1.8.0
last_updated: 2026-09-03
effective_date: 2026-09-03
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

3. Epic 歸屬與前置依賴（視情況）

- 此需求是否屬於某個既有大主題（`0-Epics/` 的 Epic）？是否必須等某個 spec 完成後才能實作（前置依賴）？
- 有任一項時：依 `templates/1-Specs/.spec-relations-template.md` 建立 `[spec-xxxxx]-RELATIONS.md`，並同步更新該 Epic 的 `EPIC_OVERVIEW.md`；歸屬衝突時停下，依 `templates/0-Epics/EPICS_RULES.md` 交使用者裁決。
- 都沒有時不建 RELATIONS.md，直接進入下一步。

## 參考規範

- `templates/COMMON_CONVENTIONS.md`
- `templates/SKILL_INTEGRATION.md`
- `templates/1-Specs/SPECS_RULES.md`
- `templates/0-Epics/EPICS_RULES.md`
- `templates/1-Specs/.spec-relations-template.md`
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

## 🔴 階段格式鐵律（每階段必須先讀規範檔，禁止憑印象產出）

> **進入任何階段前，必須先 Read 對應的 RULES 與 template 檔案，再依其規定的「資料夾命名」、「子資料夾結構」、「檔案命名」產出文件與目錄。禁止憑記憶或推測產出格式。**
>
> **每個階段對應的「進入前必讀」清單：**
>
> | 階段 | 進入前必讀（依序） |
> |------|--------------------|
> | 1-Specs | `templates/COMMON_CONVENTIONS.md`、`templates/1-Specs/SPECS_RULES.md`、`templates/1-Specs/.specs-idea-to-docs-template.md` |
> | 2-Plans | `templates/2-Plans/PLANS_RULES.md`、`templates/2-Plans/PHASE_PRIORITY_GUIDELINES.md`、`templates/2-Plans/.plan-overview-template.md`、`templates/2-Plans/.plan-template.md` |
> | 3-Progressing | `templates/3-Progressing/PROGRESSING_RULES.md`、`templates/3-Progressing/.progressing-task-template.md` |
> | 4-Testing | `templates/4-Testing/TESTINGS_RULES.md`、`templates/4-Testing/.testing-task-template.md` |
> | 7-Done | `templates/7-Done/DONE_RULES.md`、`templates/7-Done/.done-task-template.md` |
> | 8-Archived | `templates/8-Archived/ARCHIVED_RULES.md`、`templates/8-Archived/.archived-summary-template.md` |
>
> **強制執行順序（每階段都要做）：**
>
> 1. **先 Read 該階段所有 RULES / template 檔**（不得跳過或只讀標題）
> 2. **依 RULES 的「資料夾結構範例」與「檔案命名規範」實際建立目錄樹**
> 3. **依 template 的欄位逐一填入內容**（欄位不足填 placeholder，不得省略章節）
> 4. **執行 `mv` 搬移檔案**（嚴禁 `cp`）
> 5. **完成後立即驗證結構是否與 RULES 範例一致**，不一致必須修正後才進下一階段
>
> **若 SKILL.md 與 RULES 文件出現衝突，以 RULES 文件為準（RULES 是該階段的最終真相來源）。**

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
