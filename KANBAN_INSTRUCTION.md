# 語言切換

[中文版](#zh-tw) | [EN](#en) | [日本語](#jp)

---

<a id="zh-tw"></a>

# Kanban 系統核心原則與參考文件

> **文件優先順序：**
>
> 1. `COMMON_CONVENTIONS.md`（共通規範，工具中立；位於目前語系內容根目錄下的 `templates/`）
> 2. `SKILL_INTEGRATION.md`（自動化整合參數；位於目前語系內容根目錄下的 `templates/`）
> 3. 本文件 `KANBAN_INSTRUCTION.md`（核心原則）

## 🎯 系統目的

本 Kanban 系統是為了在多個 AI 工具之間協作開發而設計，透過明確的**規格 (Specs)** 與**實作計畫 (Plans)** 分層，解決 Context Window 限制與多人/多 AI 協作的同步問題，讓開發工作可以在不同 AI 工具間無縫接力。

---

## ⭐ 核心原則 (第一優先規則)

### 🎯 實作計畫 (Plans) 的最高優先級原則

**在建立計畫時，務必遵守以下優先順序：**

1. **最高優先級：程式碼相關計畫**
   - 建立或修改程式碼的計畫
   - 增加或修改功能的計畫
   - 錯誤修正和重構計畫
2. **第二優先級：測試相關計畫**
   - 只有在所有程式碼相關計畫都建立並執行完成後
   - 才開始建立和執行測試計畫
3. **最低優先級：文件相關計畫**
   - 只有在測試計畫完成後
   - 才建立文件撰寫或更新計畫

**重要說明：**

- ✅ **程式碼計畫必須優先完成** - 這是專案的核心產出
- ✅ **測試計畫緊隨其後** - 確保程式碼品質
- ✅ **文件計畫最後處理** - 文件是基於完成的程式碼撰寫的
- ❌ **不可跳過順序** - 不能先做文件而不做程式碼
- ❌ **不可同時進行不同優先級的計畫** - 必須先完成高優先級計畫

---

### 🚀 計畫並行執行原則

**最高優先級原則：最大化計畫的並行執行能力**

本系統的核心設計理念是讓**多個 AI 工具能夠同時處理不同的獨立計畫**，藉此大幅縮短整體開發時間。

#### 📋 為什麼需要並行執行？

傳統的順序執行方式：
`計畫 1 → 計畫 2 → 計畫 3 → 計畫 4` (總耗時 5.5x)

並行執行方式：

```
AI 工具 1: 計畫 1 ────────────┐
AI 工具 2: 計畫 2 ──────┐     │
AI 工具 3: 計畫 3 ────────┘     │
                             ↓
                        同時完成 (總耗時 2x)
```

**效率提升：64% 時間節省（5.5x → 2x）**

#### ✅ 計畫拆分的核心要求

在拆分計畫時（階段 1: Specs → Plans），**必須優先考慮計畫的獨立性**：

**1. 獨立性評估標準**

一個計畫是「可並行執行的獨立計畫」，當它符合以下**所有**條件：

- ✅ **檔案獨立性** - 不需要讀取或修改其他待辦計畫會建立的檔案
- ✅ **功能獨立性** - 不需要呼叫其他待辦計畫會實作的函數或 API
- ✅ **資料獨立性** - 不需要等待其他計畫的資料結構或介面定義
- ✅ **測試獨立性** - 可以使用 mock 資料或暫時的介面來獨立開發和測試

**2. 優先拆分策略**

❌ **錯誤的拆分方式（造成順序依賴）：**

```
計畫 1: 實作用戶系統
  ├─ 子計畫 1-1: 實作用戶註冊功能
  ├─ 子計畫 1-2: 實作用戶登入功能（依賴 1-1）
  └─ 子計畫 1-3: 實作個人資料功能（依賴 1-1, 1-2）
```

✅ **正確的拆分方式（獨立計畫可並行）：**

```
第一階段：基礎設施（⭐ 高優先級 - 會阻塞其他計畫）
  計畫 1 [高優先級]: 建立用戶資料模型和共用介面定義
  → 即使技術複雜度低，因為會阻塞 3 個計畫，所以是高優先級

第二階段：獨立功能（可並行執行 - 3 個 AI 工具同時處理）
  計畫 2: 實作用戶註冊 API（使用計畫 1 的介面）
  計畫 3: 實作用戶登入 API（使用計畫 1 的介面）
  計畫 4: 實作個人資料 API（使用計畫 1 的介面）
```

**3. 最小化依賴關係的技巧**

a) **介面優先策略**：先定義 API 介面與資料型別，實作並行。
b) **配置與實作分離**：先建立 Config，模組開發並行。
c) **Mock 資料解除阻塞**：前端使用 Mock API 先行開發。
d) **⭐ 阻塞性計畫的優先級評估**：會阻塞別人的計畫，無論多簡單，優先級都必須是 **Urgent** 或 **High**。

---

## 📋 通用操作規範

### 1. 停下動作，等待確認原則

**在每個重要階段完成後，AI 工具必須停下動作，等待用戶確認**

適用階段：

- **階段 1 (計畫拆分)**：Specs -> Plans 完成後
- **階段 2 (程式碼開發)**：Plans -> Progressing (實作) 完成後
- **階段 3 (測試撰寫)**：Test Code 完成後
- **階段 4 (測試執行)**：Testing -> Done 完成後

---

### 2. 計畫命名規範

**命名格式：** `[YYYY-MM-DD]-[spec-xxxxx]-[數字]-[優先級]-[plan-yyyyy]-[類別]-簡短描述.md`

- **[spec-xxxxx]**：來源規格 ID (若無則使用 `[no-spec]`)
- **[plan-yyyyy]**：本計畫唯一 ID (5 碼隨機)
- **[數字]**：優先級排序用 (1-5)

**優先級代碼：**

- `1-urgent` - 緊急 (會阻塞他人)
- `2-high` - 高 (核心功能)
- `3-mid` - 中 (一般功能)
- `4-low` - 低 (非關鍵功能)
- `5-suggest` - 建議事項

**類別代碼：**

- `feature`, `bug`, `refactor`, `test`, `docs`

**範例：**

- `2025-12-05-[spec-Ax4m2]-2-high-[plan-Az4a2]-feature-user-auth.md`
- `2025-12-05-[no-spec]-1-urgent-[plan-Bk3n7]-bug-login-crash.md`

**父層資料夾規則：**

- 無論本次有 1 個或多個 plan 文件，都必須先建立共同父層資料夾，再放入所有 plan 文件。
- 若為 `no-spec` 流程，建議父層資料夾命名為 `[YYYY-MM-DD]-[no-spec]-[feature-name]/`。

---

### 3. 檔案編號規範

**⭐ 重要：所有建立的 Specs 和 Plans 都必須加上唯一的編號前綴**

#### 編號格式

- **Specs**：`[spec-xxxxx]` (5 碼英數隨機)
- **Plans**：`[plan-xxxxx]` (5 碼英數隨機)

#### 引用規範

在文件或 Commit Message 中引用時：

- 必須使用 ID，例如：「根據 [spec-A1b2C] 實作...」
- 跨層級引用：「實作 [spec-A1b2C] 的 [plan-X9y8Z] 計畫」

---

### 4. 程式碼註解語言規範

**所有程式碼註解必須使用英文**

- 單行註解 `//`
- 多行註解 `/* */`
- 文件註解 JSDoc / TSDoc / Docstring

---

### 5. Lint 檢查規範

**⭐ 所有程式碼（功能與測試）必須通過 Lint 檢查**

- **開發階段 (Progressing)**：移至 Testing 前需通過。
- **測試階段 (Testing)**：移至 Done 前需通過。

---

### 5.5 Testing 品質閘門（強制）

只要任務文件進入 `4-Testing/`，必須同時滿足以下條件，才可推進：

1. 已建立或補齊測試程式碼（不可只移動文件）。
2. 已執行完整測試範圍（不可只跑單一測試檔）。
3. 全部測試通過（all green）。
4. 任務文件已記錄測試指令、完整輸出與統計結果。

**禁止事項：**

- ❌ 未通過品質閘門就移到 `7-Done/`。
- ❌ 未通過品質閘門就移到 `8-Archived/`。

---

### 6. 環境配置檢查規範

**在測試階段，若需連接外部服務，必須先檢查環境配置 (.env)**
若無配置，應標記為「部分完成」或移至 `On-hold`，不可強行測試導致失敗。

---

### 7. 遇到問題時參考專案文件

**⭐ 優先閱讀文件尋找解法：**

- `README.md`
- `docs/`
- `package.json` / `pyproject.toml`
- 既有的測試設定檔

---

### 8. AI 工具分配建議

| AI 工具類型                      | 適合任務                 | 建議階段                  |
| -------------------------------- | ------------------------ | ------------------------- |
| 高階推理 (Opus/Sonnet 3.5)       | 架構設計、複雜邏輯、除錯 | Specs, Progressing (Core) |
| 快速生成 (GPT-4o/Claude Instant) | CRUD、單元測試、文件     | Plans, Testing, Docs      |

---

### 9. 檔案移動規則

**檔案只能順向移動，不可跳過階段**

`1-Specs` → `2-Plans` → `3-Progressing` → `4-Testing` → `7-Done` → `8-Archived`

- **特殊流程**：
  - 測試失敗：`Testing` → `Re-testing` → `Testing`
  - 暫停：任意階段 → `6-On-hold`

**模式補充：**

- 手動模式（預設）：不得自動跨階段移動。
- 自動化模式：需明確授權後，才可依整合設定自動跨階段。
- 詳細條件以 `COMMON_CONVENTIONS.md` 與 `SKILL_INTEGRATION.md` 為準（皆位於目前語系內容根目錄下的 `templates/`）。

**移動時必須：**

1. 實體移動檔案
2. 更新檔案內容（狀態、時間、checklist）
3. 停下等待確認
4. 若移入 `4-Testing/`，必須通過「Testing 品質閘門」後，才可移到 `7-Done/` 或 `8-Archived/`
5. 若該批次有 `0-PLAN_OVERVIEW`，每次有 plan 文件跨階段移動時，必須同步更新 overview 內容（任務狀態、統計、最後更新時間）
6. 若同一批次來源資料夾中，除 `0-PLAN_OVERVIEW` 外的文件都已移到下一階段，`0-PLAN_OVERVIEW` 也必須跟著移到同一目標資料夾，並立即更新內容
7. 每一份 plan 文件在跨階段時，至少要更新兩次內容：
   - 第一次：移動當下更新「目前階段狀態」
   - 第二次：該階段工作完成後更新「完成結果與證據」
8. 同一批次在單次推進中，只能有一個目標階段，不可在同一步驟拆分到多個階段

---

### 10. 計畫卡片必要欄位規範 (Template)

所有計畫卡片必須包含：

```markdown
**計畫名稱:** [簡短描述]
**狀態:** [待辦/處理中/測試中/已完成]
**類別:** [feature/bug/refactor/test/docs]
**優先級:** [1-5]
**參考文件:** [spec-xxxxx] 路徑

**計畫描述:**
[詳細說明]

**依賴關係:** (重要！用於判斷並行)

- 依賴: [plan-xxxxx]
- 被依賴: [plan-yyyyy]
```

**不同階段新增欄位：**

- **Progressing**: `開始時間`, `負責 AI`, `開發進度 (Checklist)`, `相關程式碼`
- **Testing**: `測試開始時間`, `測試負責 AI`, `測試進度`, `測試結果`, `覆蓋率`
- **Done**: `完成時間`

---

## 11. 自動化模式整合（工具可替換）

- 本系統採用「共通規範 + 整合文件」設計，避免和單一 skill 寫死綁定。
- 若未來更換自動化工具，優先更新 `SKILL_INTEGRATION.md`（位於目前語系內容根目錄下的 `templates/`）。
- `COMMON_CONVENTIONS.md`（位於目前語系內容根目錄下的 `templates/`）保持工具中立，只維持長期不變規則。

---

**版本:** 5.2 (Testing Quality Gate Aligned)
**最後更新:** 2026-02-20

---

<a id="en"></a>

# Kanban Core Principles and References

## EN

> **Reference priority:**
>
> 1. `COMMON_CONVENTIONS.md` (shared tool-neutral rules; under the current locale content root `templates/`)
> 2. `SKILL_INTEGRATION.md` (automation integration parameters; under the current locale content root `templates/`)
> 3. This file `KANBAN_INSTRUCTION.md` (core principles)

## System Purpose

This Kanban system is designed for multi-AI collaborative development. It separates work into **Specs** and **Plans** to address context-window limitations and synchronization challenges across people and AI tools, enabling seamless handoff.

---

## Core Principles (Highest Priority Rules)

### Highest Priority Rule for Plans

When creating plans, strictly follow this priority order:

1. **Highest priority: code-related plans**

- Create or modify code
- Add or modify features
- Fix bugs and refactor

2. **Second priority: test-related plans**

- Start only after all code-related plans are created and completed

3. **Lowest priority: documentation plans**

- Start only after test plans are completed

Important notes:

- Code plans must be completed first.
- Test plans follow code plans to ensure quality.
- Documentation plans come last, based on completed code.
- Do not skip order.
- Do not run different priority classes at the same time.

### Plan Parallelization Principle

Top-level principle: maximize parallel execution capacity of plans.

The core design objective is to let multiple AI tools process different independent plans simultaneously, significantly reducing total delivery time.

#### Why Parallelization Matters

- Sequential: `Plan 1 -> Plan 2 -> Plan 3 -> Plan 4` (total around 5.5x)
- Parallel: multiple AI tools execute independent plans concurrently (total around 2x)
- Efficiency gain: about 64% time reduction (5.5x -> 2x)

#### Core Requirements for Plan Decomposition

Plan decomposition requirements (Stage 1: Specs -> Plans):

1. Independence evaluation criteria

A plan is parallelizable only if all conditions are met:

- File independence: no need to read/modify files created by other pending plans
- Functional independence: no need to call functions/APIs pending in other plans
- Data independence: no need to wait for data structures/interfaces from other plans
- Testing independence: can develop/test independently using mocks or temporary interfaces

2. Preferred decomposition strategy

- Avoid dependency-chain decomposition that enforces strict sequence.
- Prefer: first build shared base interfaces/models, then split independent APIs/features in parallel.

3. Dependency minimization techniques

- Interface-first strategy: define API contracts and data types first, then parallel implementation.
- Separate config from implementation: establish config first, then parallel module work.
- Use mocks to remove blockers: frontend can proceed with mock APIs.
- Blocking-plan priority rule: any plan blocking others should be **Urgent** or **High**, regardless of technical complexity.

---

## Shared Operational Conventions

### 1. Stop-and-Wait Confirmation Principle

After each major stage, AI tools must stop and wait for user confirmation.

Applies to:

- Stage 1 (Specs -> Plans)
- Stage 2 (Plans -> Progressing implementation)
- Stage 3 (test code writing)
- Stage 4 (Testing -> Done execution)

### 2. Plan Naming Convention

Format:
`[YYYY-MM-DD]-[spec-xxxxx]-[number]-[priority]-[plan-yyyyy]-[category]-short-description.md`

- `[spec-xxxxx]`: source spec ID (use `[no-spec]` when no spec)
- `[plan-yyyyy]`: unique plan ID (5 random chars)
- `[number]`: priority sorting number (1-5)

Priority codes:

- `1-urgent` - urgent (blocks others)
- `2-high` - high (core feature)
- `3-mid` - medium (general feature)
- `4-low` - low (non-critical)
- `5-suggest` - suggestion

Category codes:

- `feature`, `bug`, `refactor`, `test`, `docs`

Parent-folder rule:

- Whether creating one or many plan files, always create a shared parent folder first.
- For `no-spec` flow, recommended parent folder pattern: `[YYYY-MM-DD]-[no-spec]-[feature-name]/`.

### 3. File ID Convention

All created Specs and Plans must include unique ID prefixes:

#### ID Format

- Specs: `[spec-xxxxx]`
- Plans: `[plan-xxxxx]`

Reference style in docs or commit messages:

#### Reference Style

- Use IDs explicitly, e.g., "implement based on [spec-A1b2C]".
- Cross-level reference: "implement [plan-X9y8Z] from [spec-A1b2C]".

### 4. Code Comment Language

All code comments must be in English:

- Single-line comments
- Multi-line comments
- Doc comments (JSDoc/TSDoc/Docstring)

### 5. Lint Check Rule

All code (feature and tests) must pass lint checks:

- Development stage: pass lint before moving to Testing.
- Testing stage: pass lint before moving to Done.

### 5.5 Testing Quality Gate (Mandatory)

Once a task enters `4-Testing/`, all conditions below must be met before promotion:

1. Test code is created or completed (moving files only is not allowed).
2. Full testing scope is executed (not single-file-only run).
3. All tests are green.
4. Task files record commands, full output, and summary stats.

Prohibited:

- Moving to `7-Done/` without passing the quality gate.
- Moving to `8-Archived/` without passing the quality gate.

### 6. Environment Configuration Check

If testing requires external services, verify `.env` configuration first.
If configuration is missing, mark as partially completed or move to `On-hold`; do not force execution.

### 7. Read Project Docs First When Blocked

Prioritize:

- `README.md`
- `docs/`
- `package.json` / `pyproject.toml`
- existing test configuration files

### 8. AI Tool Allocation Guidance

| AI capability type                      | Best for                               | Recommended stage         |
| --------------------------------------- | -------------------------------------- | ------------------------- |
| Advanced reasoning (Opus/Sonnet 3.5)    | architecture, complex logic, debugging | Specs, Progressing (Core) |
| Fast generation (GPT-4o/Claude Instant) | CRUD, unit tests, docs                 | Plans, Testing, Docs      |

### 9. File Transition Rules

Files can only move forward by stage; no stage skipping:

`1-Specs` -> `2-Plans` -> `3-Progressing` -> `4-Testing` -> `7-Done` -> `8-Archived`

Special flows:

- Test failed: `Testing` -> `Re-testing` -> `Testing`
- Pause: any stage -> `6-On-hold`

Mode notes:

- Manual mode (default): automatic cross-stage transitions are not allowed.
- Automation mode: only with explicit authorization.
- Detailed conditions follow `COMMON_CONVENTIONS.md` and `SKILL_INTEGRATION.md` under current locale content root `templates/`.

Required actions on transition:

1. Move the file physically.
2. Update file content (status, timestamps, checklist).
3. Stop and wait for confirmation.
4. If moved into `4-Testing/`, pass Testing Quality Gate before moving to `7-Done/` or `8-Archived/`.
5. If `0-PLAN_OVERVIEW` exists in the batch, update it whenever any plan crosses stages.
6. If only `0-PLAN_OVERVIEW` remains in source folder, move it to the same target folder and update immediately.
7. Each plan must be updated at least twice during stage crossing:

- first update: current-stage status at move time
- second update: completion results and evidence after stage work

8. In a single batch push, only one target stage is allowed; do not split to multiple targets in one step.

### 10. Required Plan Card Fields (Template)

Every plan card must include:

```markdown
**Plan Name:** [short description]
**Status:** [To Do/In Progress/Testing/Done]
**Category:** [feature/bug/refactor/test/docs]
**Priority:** [1-5]
**Reference:** [spec-xxxxx] path

**Description:**
[detailed explanation]

**Dependencies:** (important for parallelization)

- Depends on: [plan-xxxxx]
- Required by: [plan-yyyyy]
```

Additional fields by stage:

- **Progressing**: `start time`, `assigned AI`, `development checklist`, `related code`
- **Testing**: `test start time`, `test owner AI`, `test progress`, `test results`, `coverage`
- **Done**: `completion time`

## 11. Automation Mode Integration (Replaceable)

- This system follows a "shared conventions + integration docs" design to avoid hard-binding to a single skill.
- If automation tooling changes, update `SKILL_INTEGRATION.md` first (under current locale content root `templates/`).
- Keep `COMMON_CONVENTIONS.md` tool-neutral and stable for long-term rules.

**Version:** 5.2 (Testing Quality Gate Aligned)
**Last Updated:** 2026-02-20

---

<a id="jp"></a>

# Kanban システムの中核原則と参照資料

## 日本語

> **参照優先順位:**
>
> 1. `COMMON_CONVENTIONS.md`（ツール中立の共通規約。現在の言語コンテンツルート `templates/` 配下）
> 2. `SKILL_INTEGRATION.md`（自動化統合パラメータ。現在の言語コンテンツルート `templates/` 配下）
> 3. 本ファイル `KANBAN_INSTRUCTION.md`（中核原則）

## システム目的

本 Kanban システムは、複数 AI ツールでの協調開発向けに設計されています。**Specs** と **Plans** を分離することで、コンテキストウィンドウ制約と人間/AI 間同期の課題を解消し、シームレスな引き継ぎを実現します。

---

## 中核原則（最優先ルール）

### Plans の最優先ルール

計画作成時は次の優先順を厳守します:

1. **最優先: コード関連計画**

- コード新規作成/修正
- 機能追加/変更
- バグ修正/リファクタリング

2. **第2優先: テスト関連計画**

- すべてのコード関連計画が完了してから開始

3. **最低優先: ドキュメント関連計画**

- テスト関連計画完了後に開始

重要事項:

- コード計画を必ず先に完了する。
- テスト計画はコード品質確保のため直後に実施する。
- ドキュメント計画は完成コードを基準に最後に行う。
- 順序の飛び越しは禁止。
- 異なる優先クラスを同時進行しない。

### 計画の並列実行原則

最上位原則: 計画の並列実行能力を最大化する。

設計の主眼は、複数 AI ツールが独立計画を同時処理し、全体リードタイムを大幅短縮することです。

#### 並列実行が必要な理由

- 逐次実行: `Plan 1 -> Plan 2 -> Plan 3 -> Plan 4`（合計約 5.5x）
- 並列実行: 複数 AI が独立計画を同時処理（合計約 2x）
- 効率改善: 約 64% の時間短縮（5.5x -> 2x）

#### 計画分解の中核要件

計画分解要件（Stage 1: Specs -> Plans）:

1. 独立性評価基準

並列可能計画は、次をすべて満たすこと:

- ファイル独立: 他の未完了計画が作成するファイルを読んだり更新したりしない
- 機能独立: 他計画で未実装の関数/API 呼び出しを必要としない
- データ独立: 他計画のデータ構造/インターフェース定義を待たない
- テスト独立: mock や暫定インターフェースで単独開発/検証可能

2. 推奨分解戦略

- 依存チェーン型分解（厳密逐次化）を避ける。
- 先に共通インターフェース/モデルを整備し、その後は独立 API/機能を並列実装する。

3. 依存最小化テクニック

- Interface-first: 先に API 契約とデータ型を定義し、実装を並列化。
- Config と実装の分離: 設定を先に整備し、モジュールを並行開発。
- mock 活用でブロッカー解除: フロント側は mock API で先行可能。
- ブロッキング計画優先: 他者を止める計画は技術難易度に関係なく **Urgent** または **High** とする。

---

## 共通運用規範

### 1. 停止して確認待ちの原則

各重要ステージ完了後、AI ツールは停止してユーザー確認を待つ。

適用対象:

- Stage 1（Specs -> Plans）
- Stage 2（Plans -> Progressing 実装）
- Stage 3（テストコード作成）
- Stage 4（Testing -> Done 実行）

### 2. 計画命名規則

形式:
`[YYYY-MM-DD]-[spec-xxxxx]-[number]-[priority]-[plan-yyyyy]-[category]-short-description.md`

- `[spec-xxxxx]`: 元 spec ID（spec が無い場合は `[no-spec]`）
- `[plan-yyyyy]`: 計画固有 ID（5 文字ランダム）
- `[number]`: 優先度並び替え用番号（1-5）

優先コード:

- `1-urgent` - 緊急（他計画を阻害）
- `2-high` - 高（コア機能）
- `3-mid` - 中（一般機能）
- `4-low` - 低（非クリティカル）
- `5-suggest` - 提案

分類コード:

- `feature`, `bug`, `refactor`, `test`, `docs`

親フォルダ規則:

- plan が 1 件でも複数でも、必ず共通親フォルダを先に作成。
- `no-spec` フローでは `[YYYY-MM-DD]-[no-spec]-[feature-name]/` を推奨。

### 3. ファイル ID 規則

作成する Specs/Plans には必ず固有 ID プレフィックスを付与:

#### ID 形式

- Specs: `[spec-xxxxx]`
- Plans: `[plan-xxxxx]`

文書やコミットでの参照規則:

#### 参照規則

- ID を明記する。例: "[spec-A1b2C] に基づき実装"。
- 階層横断参照: "[spec-A1b2C] の [plan-X9y8Z] を実装"。

### 4. コードコメント言語規則

すべてのコードコメントは英語:

- 単一行コメント
- 複数行コメント
- ドキュメントコメント（JSDoc/TSDoc/Docstring）

### 5. Lint チェック規則

すべてのコード（機能/テスト）は lint 合格必須:

- 開発ステージ: Testing 移行前に合格。
- テストステージ: Done 移行前に合格。

### 5.5 Testing 品質ゲート（必須）

タスクが `4-Testing/` に入ったら、次をすべて満たすまで昇格不可:

1. テストコードを作成または補完済み（ファイル移動のみは禁止）。
2. 全テスト範囲を実行済み（単一ファイル実行のみは不可）。
3. 全テスト合格（all green）。
4. タスク文書にコマンド、完全出力、集計結果を記録済み。

禁止事項:

- 品質ゲート未通過で `7-Done/` へ移動。
- 品質ゲート未通過で `8-Archived/` へ移動。

### 6. 環境設定チェック規則

テストで外部サービス接続が必要な場合、事前に `.env` を確認する。
未設定なら「部分完了」または `On-hold` とし、強行実行しない。

### 7. 問題発生時は先にプロジェクト文書確認

優先参照:

- `README.md`
- `docs/`
- `package.json` / `pyproject.toml`
- 既存テスト設定ファイル

### 8. AI ツール配分ガイド

| AI 能力タイプ                    | 向いている作業                     | 推奨ステージ              |
| -------------------------------- | ---------------------------------- | ------------------------- |
| 高度推論 (Opus/Sonnet 3.5)       | アーキ設計、複雑ロジック、デバッグ | Specs, Progressing (Core) |
| 高速生成 (GPT-4o/Claude Instant) | CRUD、単体テスト、文書             | Plans, Testing, Docs      |

### 9. ファイル遷移規則

ファイルは前方向にのみ移動可能。ステージ飛び越し禁止:

`1-Specs` -> `2-Plans` -> `3-Progressing` -> `4-Testing` -> `7-Done` -> `8-Archived`

特殊フロー:

- テスト失敗: `Testing` -> `Re-testing` -> `Testing`
- 一時停止: 任意ステージ -> `6-On-hold`

モード補足:

- 手動モード（既定）: 自動ステージ跨ぎ禁止。
- 自動化モード: 明示許可がある場合のみ。
- 詳細条件は現在の言語コンテンツルート `templates/` 配下 `COMMON_CONVENTIONS.md` / `SKILL_INTEGRATION.md` に従う。

遷移時必須事項:

1. ファイルを実体移動する。
2. 内容更新（状態、時刻、チェックリスト）を行う。
3. 停止して確認待ちする。
4. `4-Testing/` へ移動したら、品質ゲート通過まで `7-Done/` / `8-Archived/` へ進めない。
5. バッチ内に `0-PLAN_OVERVIEW` がある場合、plan 遷移ごとに同期更新する。
6. ソース側に `0-PLAN_OVERVIEW` だけ残ったら、同一遷移先へ移動し即時更新する。
7. 各 plan はステージ跨ぎ時に最低 2 回更新する:

- 1 回目: 移動時の現ステージ状態更新
- 2 回目: 当該ステージ完了後の結果と証跡更新

8. 単一バッチの単一推進では遷移先は 1 つのみ。1 手順で複数遷移先へ分割しない。

### 10. 計画カード必須項目（テンプレート）

すべての計画カードに以下を含める:

```markdown
**計画名:** [短い説明]
**状態:** [To Do/In Progress/Testing/Done]
**分類:** [feature/bug/refactor/test/docs]
**優先度:** [1-5]
**参照:** [spec-xxxxx] path

**説明:**
[詳細説明]

**依存関係:**（並列化判断に重要）

- Depends on: [plan-xxxxx]
- Required by: [plan-yyyyy]
```

ステージ別追加項目:

- **Progressing**: `開始時刻`, `担当 AI`, `開発チェックリスト`, `関連コード`
- **Testing**: `テスト開始時刻`, `テスト担当 AI`, `進捗`, `結果`, `カバレッジ`
- **Done**: `完了時刻`

## 11. 自動化モード統合（置換可能）

- 本システムは「共通規範 + 統合文書」設計で、単一 skill への固定依存を避ける。
- 自動化ツール変更時は、まず `SKILL_INTEGRATION.md`（現在の言語コンテンツルート `templates/` 配下）を更新する。
- `COMMON_CONVENTIONS.md` はツール中立で長期不変ルールを維持する。

**Version:** 5.2 (Testing Quality Gate Aligned)
**Last Updated:** 2026-02-20
