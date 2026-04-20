# 語言切換

[中文版](#zh-tw) | [EN](#en) | [日本語](#jp)

---

<a id="zh-tw"></a>

# AI 協作任務管理系統 - 便攜指南

> **📌 使用前提醒:**
>
> 完整原則請參考 **[KANBAN_INSTRUCTION.md](KANBAN_INSTRUCTION.md)**
> 本指南提供詳細的操作指令與範例，作為快速參考與執行依據。

---

## 🚀 快速開始

### 模式選擇（先確認）

- **手動模式（預設）**：不自動跨階段移動文件，階段切換需明確指示。
- **自動化模式**：可依 `mode/pipeline/auto_transition` 自動推進，但必須明確授權。
- 詳細參數請參考：`SKILL_INTEGRATION.md`（位於目前語系內容根目錄下的 `templates/`）
- 通用禁止與允許規則請參考：`COMMON_CONVENTIONS.md`（位於目前語系內容根目錄下的 `templates/`）

### 1. 建立新專案

**方法 1: 使用 npm script（推薦）**

```bash
# 建立新專案
npm run init <專案名稱>

# 範例
npm run init my-project-a
```

執行後會自動建立完整的資料夾結構：
`1-Specs/`, `2-Plans/`, `3-Progressing/`, `4-Testing/` ...

### 2. 建立規格文件（階段 0: Idea → Spec）

在專案的 `1-Specs/` 資料夾中建立規格文件：

```bash
# 建立規格文件資料夾
mkdir -p [專案名稱]/1-Specs/[專案名稱]

# 建立規格文件
# 使用 [spec-xxxxx] 前綴
```

**規格文件命名規則：**

- **統一格式：** `[spec-xxxxx]-檔案名稱.md`
- **範例：** `[spec-Ax4m2]-SYSTEM_DESIGN.md`

### 3. 建立實作計畫（階段 1: Spec → Plan）

**使用 AI 工具建立計畫卡片：**

1. 執行 `npm run gen` 選擇 **STAGE 1: Spec to Plan**
2. 或複製目前語系內容根目錄中的 `promps/STAGE_01_SPEC_TO_PLAN.md`
3. AI 會讀取規格文件並建立計畫卡片到 `[專案名稱]/2-Plans/`
4. **重要：** AI 會遵循並行執行原則，拆分出可獨立執行的計畫
5. **父層資料夾規則：** 無論本次會建立 1 個或多個 plan 文件，都必須先建立共同父層資料夾

### 4. 開始開發（階段 2: Plan → Progressing）

**使用 AI 工具開始開發：**

1. 執行 `npm run gen` 選擇 **STAGE 2: Plan to Progressing**
2. AI 會從 `2-Plans/` 挑選計畫並開始開發
3. **支援並行開發：** 多個 AI 工具可同時處理不同計畫

### 5. 撰寫與執行測試（階段 3 & 4）

1. **撰寫測試 (Stage 3)**: 執行 `npm run gen` 選擇 **STAGE 3**，建立測試任務並撰寫測試代碼。
2. **執行測試 (Stage 4)**: 執行 `npm run gen` 選擇 **STAGE 4**，執行完整測試範圍；通過後移至 `7-Done/`，失敗則移至 `5-Re-testing/`。

**⭐ Testing 品質閘門（強制）**

- 進入 `4-Testing/` 後，不可只移動文件。
- 必須建立/補齊測試程式碼。
- 必須執行完整測試範圍並確認 all green。
- 必須在任務文件記錄測試指令與完整輸出。
- 未通過時，不可推進到 `7-Done/` 或 `8-Archived/`。
- 若同批次有 `0-PLAN_OVERVIEW`，每次 plan 文件跨階段後都要同步更新 overview。
- 當來源資料夾只剩 `0-PLAN_OVERVIEW` 時，overview 也要跟著移到同一目標階段並更新內容。

---

## 🔄 完整工作流程

### 視覺化流程圖

```
階段 0: 需求討論（使用 Gen-Idea-to-Spec 腳本）
   ↓
[1-Specs/] 規格文件建立
   ├─ [spec-Ax4m2]-SYSTEM_DESIGN.md
   └─ [spec-ky82a]-API_SPEC.md
   ↓
階段 1: 計畫拆分（使用 Gen-Spec-to-Plan 腳本）
   ↓  ⭐ 重點：最大化計畫並行執行能力
   ↓
[2-Plans/] 實作計畫
   ├─ [spec-Ax4m2]-2-high-[plan-Az4a2]-feature-auth.md
   └─ [spec-Ax4m2]-2-high-[plan-Bk3n7]-feature-user-api.md
   ↓
階段 2: 程式碼開發（使用 Gen-Plan-to-Progressing 腳本）
   ↓  💡 並行執行：由多個 AI 工具同時處理不同計畫
   ↓
[3-Progressing/] 開發中
   ↓
   程式碼完成
   ↓
階段 3: 測試撰寫（使用 Gen-Progressing-to-Testing 腳本）
   ↓
[4-Testing/] 測試中
   ↓
階段 4: 測試執行（使用 Gen-Testing-to-Done 腳本）
   ↓
   ├─ 通過（all green + 證據完整）→ [7-Done/] 已完成
   └─ 失敗 → [5-Re-testing/] (或移回 Progressing)
   ↓
階段 5: 專案歸檔
   ↓
[8-Archived/]
```

### 各階段說明

- **[1-Specs/]** - 產品/系統設計 (Product/System Design)
- **[2-Plans/]** - 實作計畫 (Implementation Tasks)
- **[3-Progressing/]** - 正在寫程式碼 (Coding)
- **[4-Testing/]** - 正在寫/跑測試 (Testing)
- **[7-Done/]** - 已驗收完成 (Completed)
- **[8-Archived/]** - 專案結束歸檔 (Archived)

### 模式補充說明

- 手動模式下，完成工作後應先更新文件與回報，再等待下一步指示。
- 自動化模式下，若要跨階段自動執行，需先完成二次確認授權。
- 不論手動或自動化模式，只要進入 testing，一律強制套用 Testing 品質閘門。

---

## 📝 命名規範

### 規格文件 (1-Specs)

- `[spec-xxxxx]-檔案名稱.md`
- 範例：`[spec-Ax4m2]-UBER_System_Design.md`

### 計畫文件 (2-Plans)

- `[YYYY-MM-DD]-[spec-xxxxx]-[數字]-[優先級]-[plan-yyyyy]-[類別]-簡短描述.md`
- 範例：`2025-02-10-[spec-Ax4m2]-2-high-[plan-Az4a2]-feature-login.md`

---

## 📊 計畫卡片範例 (2-Plans 階段)

```markdown
**計畫名稱:** 實現用戶註冊 API 端點
**狀態:** 待辦 (To Do)
**類別:** feature
**優先級:** 2-high
**參考文件:** [spec-Ax4m2]

**計畫描述:**
實現用戶註冊的 API 端點，包含：

1. 建立 POST /api/v1/auth/register
2. 驗證 input
3. 密碼加密

**依賴關係:**

- 依賴: [plan-Bk3n7] (User Model)
```

---

## 🆘 常見問題

### Q1: 為什麼要分 Specs 和 Plans？

**A:** `Specs` 是「要做什麼 (Requirements/Design)」，`Plans` 是「怎麼做 (Implementation Steps)」。將兩者分開可以讓 AI 更專注：

- 高階 AI 專注於 Specs 設計。
- 快速 AI 專注於 Plans 實作。

### Q2: 如何在不同專案間切換？

**A:** 執行 `npm run gen` 時，選單會自動列出所有有 `1-Specs` 的專案供選擇。

### Q3: 舊的 Task 可以沿用嗎？

**A:** 建議將舊有的 `1-Plans` 資料夾手動更名為 `1-Specs`，並將其中的文件編號格式更新為 `[spec-xxxxx]`。既有的 `2-Tasks` 可更名為 `2-Plans`，但建議重新生成以符合新格式。

---

**版本:** 5.2 (Testing Quality Gate Aligned)
**最後更新:** 2026-02-20

---

<a id="en"></a>

# AI Collaboration Task System - Portable Guide

## EN

> **Before you start:**
>
> For the full authoritative principles, read [KANBAN_INSTRUCTION.md](KANBAN_INSTRUCTION.md).
> This guide provides practical steps and examples for execution.

---

## Quick Start

### Mode Selection (Confirm First)

- **Manual mode (default):** no automatic cross-stage transition. Stage movement requires explicit instruction.
- **Automation mode:** can auto-progress by `mode/pipeline/auto_transition`, but explicit authorization is required.
- Detailed parameters: `SKILL_INTEGRATION.md` (under current locale content root `templates/`).
- Shared allow/deny rules: `COMMON_CONVENTIONS.md` (under current locale content root `templates/`).

### 1. Create a New Project

Method 1: npm script (recommended)

```bash
# Create a new project
npm run init <project-name>

# Example
npm run init my-project-a
```

This command creates the full folder structure:
`1-Specs/`, `2-Plans/`, `3-Progressing/`, `4-Testing/` ...

### 2. Create Spec Documents (Stage 0: Idea -> Spec)

Create spec files under the project's `1-Specs/` folder:

```bash
# Create spec folder
mkdir -p [project-name]/1-Specs/[project-name]

# Create spec document
# Use [spec-xxxxx] prefix
```

Spec naming rules:

- Unified format: `[spec-xxxxx]-file-name.md`
- Example: `[spec-Ax4m2]-SYSTEM_DESIGN.md`

### 3. Create Implementation Plans (Stage 1: Spec -> Plan)

Use AI tools to create plan cards:

1. Run `npm run gen` and select **STAGE 1: Spec to Plan**.
2. Or copy `promps/STAGE_01_SPEC_TO_PLAN.md` under current locale content root.
3. AI reads spec docs and creates plans under `[project-name]/2-Plans/`.
4. Important: AI should split plans for parallel execution whenever possible.
5. Parent folder rule: whether creating one or many plan files, always create one shared parent folder first.

### 4. Start Development (Stage 2: Plan -> Progressing)

1. Run `npm run gen` and select **STAGE 2: Plan to Progressing**.
2. AI picks plans from `2-Plans/` and starts implementation.
3. Parallel development is supported: multiple AI tools can work on different plans at the same time.

### 5. Write and Run Tests (Stage 3 and 4)

1. Write tests (Stage 3): run `npm run gen`, select **STAGE 3**, create testing tasks and test code.
2. Execute tests (Stage 4): run `npm run gen`, select **STAGE 4**, run full testing scope; if passed, move to `7-Done/`; if failed, move to `5-Re-testing/`.

Mandatory Testing Quality Gate:

- After entering `4-Testing/`, moving files only is not allowed.
- Test code must be created or completed.
- Full testing scope must run and be all green.
- Test commands and full output must be recorded in task files.
- If not passed, do not move to `7-Done/` or `8-Archived/`.
- If there is `0-PLAN_OVERVIEW` in the same batch, update it every time any plan crosses a stage.
- If only overview remains in source folder, move overview to the same target stage and update it.

---

## Full Workflow

### Visual Flow

```text
Stage 0: Requirement discussion (Gen-Idea-to-Spec)
   ↓
[1-Specs/] Create spec docs
   ├─ [spec-Ax4m2]-SYSTEM_DESIGN.md
   └─ [spec-ky82a]-API_SPEC.md
   ↓
Stage 1: Plan decomposition (Gen-Spec-to-Plan)
   ↓  Priority: maximize parallelizable plans
   ↓
[2-Plans/] Implementation plans
   ├─ [spec-Ax4m2]-2-high-[plan-Az4a2]-feature-auth.md
   └─ [spec-Ax4m2]-2-high-[plan-Bk3n7]-feature-user-api.md
   ↓
Stage 2: Development (Gen-Plan-to-Progressing)
   ↓  Parallel execution by multiple AI tools
   ↓
[3-Progressing/] In progress
   ↓
Code complete
   ↓
Stage 3: Test writing (Gen-Progressing-to-Testing)
   ↓
[4-Testing/] Testing
   ↓
Stage 4: Test execution (Gen-Testing-to-Done)
   ↓
   ├─ Pass (all green + complete evidence) -> [7-Done/]
   └─ Fail -> [5-Re-testing/] (or back to Progressing)
   ↓
Stage 5: Archive project
   ↓
[8-Archived/]
```

### Stage Definitions

- **[1-Specs/]** - Product/System Design
- **[2-Plans/]** - Implementation Tasks
- **[3-Progressing/]** - Coding
- **[4-Testing/]** - Testing
- **[7-Done/]** - Completed
- **[8-Archived/]** - Archived

### Mode Notes

- In manual mode, after finishing work, update docs and report, then wait for next instruction.
- In automation mode, cross-stage automation requires second confirmation authorization.
- In both modes, once entering testing, the Testing Quality Gate is mandatory.

---

## Naming Rules

### Spec files (1-Specs)

- `[spec-xxxxx]-file-name.md`
- Example: `[spec-Ax4m2]-UBER_System_Design.md`

### Plan files (2-Plans)

- `[YYYY-MM-DD]-[spec-xxxxx]-[number]-[priority]-[plan-yyyyy]-[type]-short-description.md`
- Example: `2025-02-10-[spec-Ax4m2]-2-high-[plan-Az4a2]-feature-login.md`

---

## Plan Card Example (2-Plans Stage)

```markdown
**Plan Name:** Implement user registration API endpoint
**Status:** To Do
**Category:** feature
**Priority:** 2-high
**Reference:** [spec-Ax4m2]

**Description:**
Implement user registration API endpoint including:

1. Create POST /api/v1/auth/register
2. Validate input
3. Encrypt password

**Dependencies:**

- Depends on: [plan-Bk3n7] (User Model)
```

---

## FAQ

### Q1: Why separate Specs and Plans?

**A:** `Specs` define what to build (requirements/design), while `Plans` define how to build (execution steps). This separation improves AI focus:

- Higher-capability AI focuses on Specs design.
- Faster AI focuses on Plans implementation.

### Q2: How do I switch between projects?

**A:** When you run `npm run gen`, the menu lists all projects that include `1-Specs`.

### Q3: Can I reuse old tasks?

**A:** Recommended migration is:

- Rename old `1-Plans` to `1-Specs` and update document IDs to `[spec-xxxxx]`.
- Rename old `2-Tasks` to `2-Plans`; regenerating plans is recommended to match the new format.

**Version:** 5.2 (Testing Quality Gate Aligned)
**Last Updated:** 2026-02-20

---

<a id="jp"></a>

# AI 協調タスク管理システム - ポータブルガイド

## 日本語

> **利用前の注意:**
>
> 正式な原則は [KANBAN_INSTRUCTION.md](KANBAN_INSTRUCTION.md) を必ず参照してください。
> 本ガイドは日常運用向けの実務手順と例です。

---

## クイックスタート

### モード選択（先に確認）

- **手動モード（既定）:** ステージ自動遷移なし。遷移には明示指示が必要。
- **自動化モード:** `mode/pipeline/auto_transition` に基づき自動推進可能だが、明示許可が必須。
- 詳細パラメータ: `SKILL_INTEGRATION.md`（現在の言語コンテンツルート `templates/` 配下）。
- 共通許可/禁止ルール: `COMMON_CONVENTIONS.md`（現在の言語コンテンツルート `templates/` 配下）。

### 1. 新規プロジェクト作成

方法 1: npm script（推奨）

```bash
# 新規プロジェクト作成
npm run init <project-name>

# 例
npm run init my-project-a
```

実行後、以下の構造が自動作成されます:
`1-Specs/`, `2-Plans/`, `3-Progressing/`, `4-Testing/` ...

### 2. 仕様書作成（Stage 0: Idea -> Spec）

プロジェクトの `1-Specs/` 配下に仕様書を作成:

```bash
# 仕様フォルダ作成
mkdir -p [project-name]/1-Specs/[project-name]

# 仕様書作成
# [spec-xxxxx] プレフィックスを使用
```

仕様書の命名規則:

- 統一形式: `[spec-xxxxx]-file-name.md`
- 例: `[spec-Ax4m2]-SYSTEM_DESIGN.md`

### 3. 実装計画作成（Stage 1: Spec -> Plan）

AI ツールで Plan カードを作成:

1. `npm run gen` を実行し **STAGE 1: Spec to Plan** を選択。
2. または現在の言語コンテンツルート配下 `promps/STAGE_01_SPEC_TO_PLAN.md` を利用。
3. AI が spec を読み、`[project-name]/2-Plans/` に plan を作成。
4. 重要: 並列実行可能な独立計画を優先して分割する。
5. 親フォルダ規則: plan が 1 件でも複数でも、必ず共通親フォルダを先に作成する。

### 4. 開発開始（Stage 2: Plan -> Progressing）

1. `npm run gen` を実行し **STAGE 2: Plan to Progressing** を選択。
2. AI が `2-Plans/` から計画を選択して実装開始。
3. 並列開発対応: 複数 AI ツールが別計画を同時処理可能。

### 5. テスト作成と実行（Stage 3 と 4）

1. テスト作成（Stage 3）: `npm run gen` で **STAGE 3** を選び、テストタスクとテストコードを作成。
2. テスト実行（Stage 4）: `npm run gen` で **STAGE 4** を選び、全範囲テスト実行。合格なら `7-Done/`、失敗なら `5-Re-testing/`。

Testing 品質ゲート（必須）:

- `4-Testing/` 入り後はファイル移動のみ禁止。
- テストコードを新規作成または補完する。
- 全範囲テスト実行と all green が必須。
- テストコマンドと完全出力をタスク文書に記録する。
- 未通過時は `7-Done/` / `8-Archived/` に進めない。
- 同一バッチに `0-PLAN_OVERVIEW` がある場合、plan の各遷移後に同期更新する。
- ソース側に overview だけ残る場合、同じ遷移先へ移動して内容更新する。

---

## 完整ワークフロー

### 可視化フロー

```text
Stage 0: 要件検討（Gen-Idea-to-Spec）
   ↓
[1-Specs/] 仕様書作成
   ├─ [spec-Ax4m2]-SYSTEM_DESIGN.md
   └─ [spec-ky82a]-API_SPEC.md
   ↓
Stage 1: 計画分解（Gen-Spec-to-Plan）
   ↓  優先: 並列実行可能な計画を最大化
   ↓
[2-Plans/] 実装計画
   ├─ [spec-Ax4m2]-2-high-[plan-Az4a2]-feature-auth.md
   └─ [spec-Ax4m2]-2-high-[plan-Bk3n7]-feature-user-api.md
   ↓
Stage 2: 開発（Gen-Plan-to-Progressing）
   ↓  複数 AI による並列実行
   ↓
[3-Progressing/] 開発中
   ↓
コード完成
   ↓
Stage 3: テスト作成（Gen-Progressing-to-Testing）
   ↓
[4-Testing/] テスト中
   ↓
Stage 4: テスト実行（Gen-Testing-to-Done）
   ↓
   ├─ 合格（all green + 証跡完備）-> [7-Done/]
   └─ 失敗 -> [5-Re-testing/]（または Progressing 戻し）
   ↓
Stage 5: プロジェクトアーカイブ
   ↓
[8-Archived/]
```

### 各ステージ定義

- **[1-Specs/]** - Product/System Design
- **[2-Plans/]** - Implementation Tasks
- **[3-Progressing/]** - Coding
- **[4-Testing/]** - Testing
- **[7-Done/]** - Completed
- **[8-Archived/]** - Archived

### モード補足

- 手動モードでは、作業完了後に文書更新と報告を行い、次指示を待つ。
- 自動化モードでステージ跨ぎ自動実行する場合、二次確認の許可が必要。
- 手動/自動化に関わらず、testing に入ったら品質ゲートは強制。

---

## 命名規則

### 仕様書（1-Specs）

- `[spec-xxxxx]-file-name.md`
- 例: `[spec-Ax4m2]-UBER_System_Design.md`

### 計画ファイル（2-Plans）

- `[YYYY-MM-DD]-[spec-xxxxx]-[number]-[priority]-[plan-yyyyy]-[type]-short-description.md`
- 例: `2025-02-10-[spec-Ax4m2]-2-high-[plan-Az4a2]-feature-login.md`

---

## Plan カード例（2-Plans）

```markdown
**Plan Name:** ユーザー登録 API エンドポイント実装
**Status:** To Do
**Category:** feature
**Priority:** 2-high
**Reference:** [spec-Ax4m2]

**Description:**
以下を含むユーザー登録 API を実装:

1. POST /api/v1/auth/register 作成
2. 入力検証
3. パスワード暗号化

**Dependencies:**

- Depends on: [plan-Bk3n7] (User Model)
```

---

## よくある質問

### Q1: なぜ Specs と Plans を分けるのですか？

**A:** `Specs` は「何を作るか（要件/設計）」、`Plans` は「どう作るか（実行手順）」です。分離することで AI の集中対象を明確化できます:

- 高能力 AI は Specs 設計に集中。
- 高速 AI は Plans 実装に集中。

### Q2: プロジェクト間の切り替え方法は？

**A:** `npm run gen` 実行時、`1-Specs` がある全プロジェクトがメニューに表示されます。

### Q3: 旧 Task は流用できますか？

**A:** 推奨移行手順:

- 旧 `1-Plans` を `1-Specs` へリネームし、文書 ID を `[spec-xxxxx]` 形式に更新。
- 旧 `2-Tasks` を `2-Plans` へリネーム可能。新形式に合わせるため再生成を推奨。

**Version:** 5.2 (Testing Quality Gate Aligned)
**Last Updated:** 2026-02-20
