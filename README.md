# 語言切換

[中文版](#zh-tw) | [EN](#en) | [日本語](#jp)

---

<a id="zh-tw"></a>

# AI協作任務看板管理系統

## 中文版

> **📌 重要提醒:**
>
> **使用本系統前,請務必先閱讀 [KANBAN_INSTRUCTION.md](KANBAN_INSTRUCTION.md)**
>
> 該文件包含:
>
> - ⭐ 計畫並行執行原則 (最高優先級原則)
> - 📋 通用操作規範 (所有階段共同遵守)
> - 🎯 系統核心設計理念 (Specs vs Plans)
> - 🤖 手動模式/自動化模式的通用原則
>
> **詳細操作指南請參閱 [KANBAN_USAGE_GUIDE.md](KANBAN_USAGE_GUIDE.md)**
>
> **所有文件內容如與 KANBAN_INSTRUCTION.md 衝突,以 KANBAN_INSTRUCTION.md 為準。**

---

## 🎯 系統概述

這是一個專為 **AI 工具協作開發**設計的任務管理系統。支援多個 AI 工具在不同專案間無縫接力，透過清楚的 **規格 (Specs)** 與 **實作計畫 (Plans)** 分層，最大化開發效率。

**核心特色:**

- 🤖 **多 AI 協作**：支援多種 AI 工具協作開發
- ⚡ **並行執行**：最大化計畫並行執行能力，大幅縮短開發時間
- 🔄 **無縫接力**：解決 AI 工具額度限制，在不同 AI 視窗/對話間無縫切換
- 📊 **集中式管理**：統一的模板和規則，確保所有專案一致性
- 📁 **雙層架構**：
  - **1-Specs**: 產品需求與系統設計 (What & Why)
  - **2-Plans**: 具體實作步驟與任務 (How & When)

---

### 🛠️ 專案初始化與靈活運用

**1. 標準流程 (透過 Script 建立):**

- 使用 `npm run init <專案名稱>` 快速建立完整的專案資料夾結構。
- **完整流程:**
  `1-Specs/` (規格) → `2-Plans/` (拆解) → `3-Progressing/` (開發) → `4-Testing/` (測試) → `7-Done/` (完成) → `8-Archived/` (歸檔)

**2. 靈活運用:**

- **直接新增計畫:** 若有無需完整規格的小型修改，可以直接建立 `[no-spec]` 計畫；無論建立 1 個或多個 plans，都必須先建立共同父層資料夾。
- **多專案並行:** 支援同時管理多個專案，路徑清晰互不干擾。

---

### 🤖 自動化模式（可替換）

- **預設模式：手動模式**，不自動跨階段移動任務文件。
- **自動化模式：** 只有在使用者明確授權 `auto_transition=true` 時，才允許自動跨階段。
- **工具中立：** 共通原則在 `COMMON_CONVENTIONS.md`，工具細節在 `SKILL_INTEGRATION.md`（皆以目前語系內容根目錄為準）。
- **可替換設計：** 未來若更換或淘汰 skill，只需更新整合文件，不需重寫整體規範。

### 🧪 Testing 品質閘門（強制）

- 只要任務進入 `4-Testing/`，不可只移動文件。
- 必須建立/補齊測試程式碼。
- 必須執行完整測試範圍並確認 all green。
- 必須在任務文件記錄測試指令與完整輸出。
- 未通過時，不可推進到 `7-Done/` 或 `8-Archived/`。
- 若同批次有 `0-PLAN_OVERVIEW`，每次 plan 文件跨階段後都必須同步更新 overview。
- 若來源資料夾中只剩 overview，overview 必須跟著移到同一目標階段並更新內容。

---

## 📁 資料夾結構

```
my-kanban/
├── README.md                       # 本文件 - 專案入口
├── KANBAN_INSTRUCTION.md           # 核心原則與參考文件（必讀）
├── KANBAN_USAGE_GUIDE.md           # 完整使用操作指南
├── package.json                    # NPM 專案設定檔
│
├── <語系內容根目錄>/               # 例如 zh-TW/、ja-JP/、en-US/
│   ├── scripts/                    # 自動化腳本
│   │   ├── init-project-kanban.sh
│   │   ├── gen-prompt.sh
│   │   └── ...
│   ├── templates/                  # 集中式模板與規則
│   │   ├── COMMON_CONVENTIONS.md
│   │   ├── SKILL_INTEGRATION.md
│   │   └── ...
│   ├── promps/                     # AI 提示詞庫（按階段）
│   └── skills/                     # 自訂 skills
```

## 📚 相關文件導引

### 1. 核心觀念（必讀）

**👉 [KANBAN_INSTRUCTION.md](KANBAN_INSTRUCTION.md)**

- 計畫並行執行原則
- 獨立性評估標準
- 計畫命名與編號規範
- 手動模式與自動化模式切換原則

### 2. 操作指南（How-to）

**👉 [KANBAN_USAGE_GUIDE.md](KANBAN_USAGE_GUIDE.md)**

- 快速開始步驟
- 完整工作流程圖
- 計畫卡片範例

### 3. 共通規範與自動化整合（推薦）

- **👉 `COMMON_CONVENTIONS.md`（位於目前語系內容根目錄下的 `templates/`）**
- **👉 `SKILL_INTEGRATION.md`（位於目前語系內容根目錄下的 `templates/`）**

---

**版本:** 5.2 (Testing Quality Gate Aligned)
**最後更新:** 2026-02-20

---

<a id="en"></a>

# AI Collaboration Kanban System

## EN

> **Important:**
>
> Before using this system, read [KANBAN_INSTRUCTION.md](KANBAN_INSTRUCTION.md) first.
>
> It defines:
>
> - Plan parallelization principles (highest priority)
> - Shared operational rules across all stages
> - Core design model (Specs vs Plans)
> - Manual mode and automation mode principles
>
> For detailed operation steps, see [KANBAN_USAGE_GUIDE.md](KANBAN_USAGE_GUIDE.md).
>
> If any document conflicts with KANBAN_INSTRUCTION.md, KANBAN_INSTRUCTION.md takes precedence.

---

## System Overview

This is a task management system designed for multi-AI collaboration across projects.
It separates work into:

- **1-Specs**: Requirements and design (What & Why)
- **2-Plans**: Implementation tasks and execution steps (How & When)

Key capabilities:

- Multi-AI collaboration
- Parallel execution for higher throughput
- Handoff across AI sessions/windows
- Centralized templates and conventions

### Project Initialization and Flexible Usage

1. Standard flow (created by script):

- Run `npm run init <project-name>` to create a full project folder structure quickly.
- Full flow:
  `1-Specs/` -> `2-Plans/` -> `3-Progressing/` -> `4-Testing/` -> `7-Done/` -> `8-Archived/`

2. Flexible usage:

- Direct plan creation: for small changes, you can create `[no-spec]` plans directly. Even if only one plan is created, a shared parent folder is still required.
- Multi-project parallel management: you can manage multiple projects at the same time with isolated paths.

### Automation Mode (Replaceable)

- Default mode: manual mode, no automatic cross-stage transitions.
- Automation mode: cross-stage transitions are allowed only with explicit authorization `auto_transition=true`.
- Tool-neutral design: shared principles are in `COMMON_CONVENTIONS.md`; tool details are in `SKILL_INTEGRATION.md` (both under the current locale content root).
- Replaceable integration: if automation tooling changes in the future, update integration docs without rewriting the whole rule system.

### Testing Quality Gate (Mandatory)

- Once a task enters `4-Testing/`, moving files only is not allowed.
- Test code must be created or completed.
- Full testing scope must be executed and pass all green.
- Test commands and full output must be recorded in task files.
- If not passed, do not move to `7-Done/` or `8-Archived/`.
- If `0-PLAN_OVERVIEW` exists in the same batch, update it every time a plan moves stages.
- If only `0-PLAN_OVERVIEW` remains in the source folder, move it to the same target stage and update it.

## Folder Structure

```text
my-kanban/
├── README.md
├── KANBAN_INSTRUCTION.md
├── KANBAN_USAGE_GUIDE.md
├── package.json
├── <locale-content-root>/   # e.g. zh-TW/, ja-JP/, en-US/
│   ├── scripts/
│   ├── templates/
│   ├── promps/
│   └── skills/
```

## Related Docs

### 1. Core Concepts (Required)

**-> [KANBAN_INSTRUCTION.md](KANBAN_INSTRUCTION.md)**

- Plan parallelization principles
- Independence evaluation standards
- Plan naming and ID conventions
- Manual mode and automation mode switching principles

### 2. Operation Guide (How-to)

**-> [KANBAN_USAGE_GUIDE.md](KANBAN_USAGE_GUIDE.md)**

- Quick start steps
- Full workflow diagram
- Plan card examples

### 3. Shared Conventions and Automation Integration (Recommended)

- **-> `COMMON_CONVENTIONS.md` (under current locale content root `templates/`)**
- **-> `SKILL_INTEGRATION.md` (under current locale content root `templates/`)**

**Version:** 5.2 (Testing Quality Gate Aligned)
**Last Updated:** 2026-02-20

---

<a id="jp"></a>

# AI協調タスク・カンバン管理システム

## 日本語

> **重要:**
>
> このシステムを使う前に、必ず [KANBAN_INSTRUCTION.md](KANBAN_INSTRUCTION.md) を読んでください。
>
> 主な内容:
>
> - 計画の並列実行原則（最優先）
> - 全ステージ共通の運用ルール
> - コア設計（Specs と Plans の分離）
> - 手動モードと自動化モードの原則
>
> 詳細な操作は [KANBAN_USAGE_GUIDE.md](KANBAN_USAGE_GUIDE.md) を参照してください。
>
> 内容が競合する場合は KANBAN_INSTRUCTION.md を優先します。

---

## システム概要

このシステムは、複数の AI ツールで協調開発するためのタスク管理基盤です。
作業を次の 2 層に分離します。

- **1-Specs**: 要件と設計（What & Why）
- **2-Plans**: 実装タスクと実行手順（How & When）

主な特長:

- 複数 AI の協調作業
- 並列実行による開発速度向上
- AI セッション間のスムーズな引き継ぎ
- テンプレートと規約の集中管理

### プロジェクト初期化と柔軟運用

1. 標準フロー（スクリプト生成）:

- `npm run init <project-name>` で完全なプロジェクトフォルダ構成を素早く生成。
- 完整フロー:
  `1-Specs/` -> `2-Plans/` -> `3-Progressing/` -> `4-Testing/` -> `7-Done/` -> `8-Archived/`

2. 柔軟運用:

- 直接 Plan 作成: 小規模変更は `[no-spec]` 計画を直接作成可能。1 件でも共通親フォルダは必須。
- 複数プロジェクト並行管理: パスを分離したまま同時進行可能。

### 自動化モード（置換可能）

- 既定: 手動モード（ステージ自動遷移なし）。
- 自動化モード: `auto_transition=true` の明示許可時のみステージ跨ぎを許可。
- ツール中立設計: 共通原則は `COMMON_CONVENTIONS.md`、ツール詳細は `SKILL_INTEGRATION.md`（いずれも現在の言語コンテンツルート配下）。
- 将来の置換性: 自動化ツールが変わっても整合文書の更新で対応可能。

### Testing 品質ゲート（必須）

- `4-Testing/` 入り後は、ファイル移動のみは禁止。
- テストコードを新規作成または補完する。
- 全範囲のテストを実行し、all green を確認する。
- テストコマンドと完全出力をタスク文書に記録する。
- 未通過時は `7-Done/` / `8-Archived/` へ進めない。
- 同一バッチに `0-PLAN_OVERVIEW` がある場合、plan 移動のたびに同期更新する。
- ソース側に overview だけ残る場合、同じ遷移先へ移動して内容更新する。

## フォルダ構成

```text
my-kanban/
├── README.md
├── KANBAN_INSTRUCTION.md
├── KANBAN_USAGE_GUIDE.md
├── package.json
├── <locale-content-root>/   # 例: zh-TW/, ja-JP/, en-US/
│   ├── scripts/
│   ├── templates/
│   ├── promps/
│   └── skills/
```

## 関連ドキュメント

### 1. コア概念（必読）

**-> [KANBAN_INSTRUCTION.md](KANBAN_INSTRUCTION.md)**

- 計画の並列実行原則
- 独立性評価基準
- 計画命名と ID 規則
- 手動モードと自動化モードの切替原則

### 2. 操作ガイド（How-to）

**-> [KANBAN_USAGE_GUIDE.md](KANBAN_USAGE_GUIDE.md)**

- クイックスタート手順
- 完整ワークフロー図
- Plan カード例

### 3. 共通規範と自動化統合（推奨）

- **-> `COMMON_CONVENTIONS.md`（現在の言語コンテンツルート `templates/` 配下）**
- **-> `SKILL_INTEGRATION.md`（現在の言語コンテンツルート `templates/` 配下）**

**Version:** 5.2 (Testing Quality Gate Aligned)
**Last Updated:** 2026-02-20
