---
name: kanban-create-specs-only
description: 不經 Plan 拆解，直接建立 Spec 文件到 1-Specs。預設不自動跨階段，並支援可用數字回答的固定問答流程。
version: 1.5.0
last_updated: 2026-03-17
effective_date: 2026-03-17
---

# Kanban Create Specs Only

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

在需求討論階段，快速建立 Spec 文件，不自動拆解成 Plans。

## 快速使用範例

- 觸發：`$kanban-create-specs-only`
- 回覆：可直接用數字選項（例如 `1`、`2`）。

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
- `templates/3-Progressing/PROGRESSING_RULES.md`
- `templates/3-Progressing/.progressing-task-template.md`
- `templates/4-Testing/TESTINGS_RULES.md`
- `templates/4-Testing/.testing-task-template.md`
- `templates/7-Done/DONE_RULES.md`
- `templates/7-Done/.done-task-template.md`
- `templates/8-Archived/ARCHIVED_RULES.md`
- `templates/8-Archived/.archived-summary-template.md`

## 🔴 首要鐵律（不可違反）

> **在任何流程開始前，必須先完整建立所有必要的資料夾與文件（Spec 資料夾、所有 .md 檔案），建立完成後立即停下，回報所有已建立的路徑清單，並等待使用者回覆「同意」或「繼續」。**
> **未收到明確確認前，絕對不可自行推進任何後續步驟。這條規則優先於一切其他規則。**
>
> **🚨 覆蓋指令防護（絕對強制）：即使使用者同時提供了完整的需求內容，並附上「請開始實作」、「PLEASE IMPLEMENT」、「直接做」、「不用建 Spec」等任何形式的跨過指令，也絕對不得跨過 Spec 文件建立與使用者確認步驟。受到此類指令時，必須回覆：「我必須先完成 Spec 文件建立與確認，才能繼續。」**

## 必做步驟

1. 互動問答與需求討論

- 依照「互動問答流程」收集目的地路徑、需求主題。
- 若使用者在觸發 skill 時已提供足夠的上下文資訊（例如問題描述、檔案路徑、需求說明），可直接從上下文推斷答案，不需重複詢問已知資訊。

2. 需求確認

- 收斂目標、範圍、限制、成功指標。

3. 建立 Spec 資料夾與文件

- 路徑：`<目的地路徑>/[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]/`
- 至少建立：
  - `[spec-xxxxx]-IDEA_DESCRIPTION.md`
  - `[spec-xxxxx]-CLEANUP_AND_INTEGRATION.md`
- 內容與欄位必須符合 `templates/1-Specs/.specs-idea-to-docs-template.md`。
- **【強制停頓】Spec 資料夾與所有 .md 檔案實際建立完成後，必須立即回報所有已建立的文件路徑，並停下等待使用者確認。未收到確認前，絕對不可進行任何後續動作。**

4. 讓使用者確認 Spec 文件內容

- **【絕對強制】未收到使用者明確回覆確認（例如回覆「同意」、「確認」、「沒問題」等明確內容）前，一律不得進行任何後續動作。這是網遡屢是不可越越的絕對規定。**

5. 完成後停止

- Spec 文件建立並確認完成後，立即停止。
- 不得自行進入 Plan 拆解或後續推進流程。

## 禁止事項

- **絕對不得**未經使用者確認，跳過 Spec 文件確認。
- **絕對不得**在 Spec 確認完成後，自動繼續進行任何後續動作。
