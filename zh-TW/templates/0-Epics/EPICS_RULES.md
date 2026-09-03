# Epics 資料夾規範

> 本文件是給 AI 的指引，說明 Epic（大主題）層的定位、文件結構、關聯宣告（歸屬與前置依賴）與生命週期管理。
>
> **📌 共通規範：**
>
> 所有 Epic 文件都必須遵循 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md) 定義的命名、編號和標記規則。
>
> **重要：本文件是 Epic 層的最終真相來源。若 skill 文件（例如 `kanban-manage-epics`）與本文件衝突，以本文件為準。**

**Version:** 1.0.0
**Last Updated:** 2026-09-03
**Effective Date:** 2026-09-03

---

## 🎯 Epic 的定位

Epic 解決兩個既有結構做不到的事：

1. **spec 之間有實作先後依賴**：B spec 的實作必須等 A spec 完成（例：增量同步依賴 cursor 分頁的機制與索引，實作順序不能反）。
2. **大主題底下收納多個子題**：一個大方向（例：「食譜列表規模化」）拆成多個獨立 spec，需要一個地方彙總全貌與推進狀態。

層級關係：**Epic > Spec > Plan**。Epic 底下掛 spec，spec 底下拆 plan。

## 🧭 核心原則（一切操作的前提）

1. **Epic 是引用型索引，不是容器**：子 spec 永遠留在自己所在的階段資料夾（`1-Specs/` ～ `8-Archived/`），Epic 只登記引用。**任何 Epic 操作都不得搬動子 spec 的檔案或資料夾。**
2. **依賴是 spec 自己的基礎欄位**：前置宣告寫在各 spec 的 `RELATIONS.md`，不需要先有 Epic 才能宣告；依賴可以跨 Epic。
3. **單一歸屬**：一個 spec 最多屬於一個 Epic。跨 Epic 的需求一律改走前置依賴宣告，嚴禁雙重歸屬。
4. **層級只有一層**：Epic 底下只能掛 spec，不支援 Epic 掛 Epic（巢狀）。
5. **內容分層判準**：只跟單一子 spec 有關的內容，不得寫進 Epic 文件，一律下放該子 spec。Epic 文件只寫「跨子題」的內容，避免雙重真實來源。
6. **Epic 不走一般階段流程**：Epic 的生命週期是所有子 spec 的聯集，停留在 `0-Epics/` 直到收場歸檔（見生命週期章節），不在 1～7 階段之間移動。

---

## 📁 資料夾結構與命名

`0-Epics/` 位於 kanban 專案根目錄，與 `1-Specs/` ～ `8-Archived/` 平行。專案尚無此資料夾時，於建立第一個 Epic 時一併建立。

```
專案根目錄/
├── 0-Epics/
│   └── [YYYY-MM-DD]-[epic-xxxxx]-[theme-name]/
│       ├── [epic-xxxxx]-EPIC_OVERVIEW.md      ← 必備
│       ├── [epic-xxxxx]-EPIC_DESCRIPTION.md   ← 必備
│       └── [epic-xxxxx]-[其他選擇性文件].md
├── 1-Specs/
├── 2-Plans/
└── ...
```

**命名規則：**

- 資料夾：`[YYYY-MM-DD]-[epic-xxxxx]-[theme-name]/`，日期為 Epic 成立日期，`theme-name` 使用小寫英文、單字間以 `-` 連接。
- 編號：`[epic-xxxxx]`，5 碼，由英文大小寫（A-Z, a-z）與數字（0-9）隨機組成（同 `COMMON_CONVENTIONS.md` 編號規則）。
- **同一個 Epic 資料夾內的所有文件必須使用相同編號。**
- 引用格式：文件中提及 Epic 時寫 `[epic-xxxxx]`，比照 `[spec-xxxxx]` 慣例。

## 📄 文件組合

### 必備文件（每個 Epic 都要有）

#### 1. EPIC_OVERVIEW.md

**用途：** 子 spec 索引、依賴順序、狀態彙總。使用者只看這一份，就能掌握整個主題的推進狀態。

- 格式依 [.epic-overview-template.md](.epic-overview-template.md)。
- 「目前階段」「位置索引」「統計」在子 spec 每次跨階段移動時同步更新（見 EPIC_OVERVIEW 同步規範）。

#### 2. EPIC_DESCRIPTION.md

**用途：** 主題層的問題陳述、整體目標、成功指標、範圍界定（對應 spec 層的 IDEA_DESCRIPTION，但在主題尺度）。

- 格式依 [.epic-description-template.md](.epic-description-template.md)。

### 選擇性文件（視主題複雜度建立）

- **ROADMAP.md** — 子題拆分邏輯、為什麼這樣排順序、里程碑。
- **ARCHITECTURE.md** — 跨子題的整體架構全景（各子 spec 只描述自己那塊）。
- **DECISION_LOG.md** — 主題層決策記錄（橫跨子題的裁示）。
- **SCOPE_BOUNDARY.md** — 子題間的邊界劃分（什麼歸哪個子題，防止重疊或漏接）。

**⚠️ 禁止套用 spec 的完整文件清單**（API_DESIGN 等實作細節文件）：那會誘導把子題細節寫進 Epic，違反內容分層判準。

---

## 🔗 關聯檔 RELATIONS.md（spec 側）

spec 與 Epic 的歸屬、spec 之間的前置依賴，統一寫在**該 spec 資料夾內**的 `[spec-xxxxx]-RELATIONS.md`（與其他 spec 文件同層、同編號前綴）。

- 格式依 [../1-Specs/.spec-relations-template.md](../1-Specs/.spec-relations-template.md)。
- **沒有任何關聯的 spec 不建此檔。**
- 「所屬 Epic」為**單值欄位**（最多一項），是歸屬的**唯一權威來源（SSOT）**。機械檢查發現多於一項即為資料損壞，停下回報。
- 「前置 Spec」每筆必須附一句依賴理由（依賴什麼成果）。
- 既有 spec 要掛入 Epic 或補宣告依賴時，只是新增這個檔，不動其他文件。
- **已在 `8-Archived/` 的 spec 不建立也不修改 RELATIONS.md**（歸檔內容不可變動）；掛入 Epic 時僅在 EPIC_OVERVIEW 單向登記，備註標明「已歸檔，僅單向登記」。

## ⛓️ 依賴閘門語意（統一定義）

| 階段 | 行為 |
|------|------|
| 建卡（1-Specs） | **不擋**。前置未完成也可以先寫規格（規格先行）。 |
| 拆 plan（2-Plans） | **警告不阻擋**。提示「前置 [spec-xxxxx] 尚未完成，plan 細節可能過時」，由使用者當場決定。 |
| 進 3-Progressing | **硬閘門**。所有前置 spec 必須已在 `7-Done/` 或 `8-Archived/`（已歸檔＝已滿足），否則停下回報，不得自動繼續。 |

**覆寫規則：** 使用者明示覆寫才可放行進 3-Progressing，且必須在該 spec 的 `RELATIONS.md`「覆寫記錄」區留下日期與理由。

**檢查責任：** 執行跨階段移動的一方（推進類 skill 或手動流程）負責在 Stage Entry Gate 執行此檢查（詳見 `COMMON_CONVENTIONS.md`）。

**循環依賴：** 禁止自我依賴與循環依賴（A→B→A）；宣告前置時偵測到循環，停下回報。

## 🏷️ 歸屬規則與衝突裁決

把 spec 掛入 Epic（或轉移）前，**必須**先讀取該 spec 的 `RELATIONS.md`「所屬 Epic」欄位：

- 欄位為空或檔案不存在 → 可直接掛入，完成**雙向登記**（spec 側 RELATIONS.md ＋ Epic 側 EPIC_OVERVIEW.md，兩邊都要寫）。
- 欄位已寫著另一個 Epic → **立刻停下，嚴禁自動處理**，向使用者呈現三個選項並等待裁決：
  1. **轉移**：從原 Epic 移除、改掛新 Epic（原 Epic、新 Epic、spec 三處一次更新）。
  2. **改用依賴**：不改變歸屬，改為在需求方 spec 宣告前置依賴（依賴可跨 Epic）。
  3. **拆新 spec**：新 Epic 需要的其實是另一件事，另立新卡。

## 🔄 EPIC_OVERVIEW 同步規範（強制）

比照 `COMMON_CONVENTIONS.md` 的 PLAN_OVERVIEW 同步規範：

1. 任何 spec 跨階段移動時，若其 `RELATIONS.md` 有所屬 Epic，執行移動的一方**必須**同步更新該 Epic 的 `EPIC_OVERVIEW.md`：目前階段、位置索引、統計、最後更新時間。
2. 禁止讓 EPIC_OVERVIEW 長期停留在與實際檔案位置不符的狀態。
3. 發現彙總與實際不符時，以**實際檔案位置**為準修正；RELATIONS 與索引表的歸屬記載衝突時，以 **RELATIONS 的「所屬 Epic」欄位**為權威來源。

---

## ♻️ 生命週期

### 建立

1. 產生 `[epic-xxxxx]` 編號，建立資料夾與兩個必備文件。
2. 建立後停下，回報路徑清單等使用者確認。

### 掛入／退出／轉移

- 均為純文件操作（RELATIONS.md ＋ EPIC_OVERVIEW.md），不搬動任何子 spec。
- 掛入與轉移必過歸屬衝突檢查；退出時前置依賴宣告保留（依賴與歸屬互不影響）。

### 解散

- 所有子 spec 的 RELATIONS.md 所屬 Epic 改「無」（已歸檔的除外），子 spec 的階段與內容完全不受影響。
- Epic 資料夾處置（刪除或保留標記「已解散」）由使用者決定。
- **必須經使用者明示確認才可執行。**

### 收場歸檔

前提（缺一不可）：

1. 索引表中**所有**子 spec 的實際位置皆已在 `8-Archived/`——以實際掃描結果為準，不信任 OVERVIEW 記載。
2. 使用者明示確認要收場歸檔。

流程：

1. 歸檔前更新 `EPIC_OVERVIEW.md`：狀態改「已歸檔 (Archived)」、位置索引全數補上各子 spec 的最終歸檔路徑。
2. 讀取 [../8-Archived/ARCHIVED_RULES.md](../8-Archived/ARCHIVED_RULES.md) 與 [.archived-summary-template.md](../8-Archived/.archived-summary-template.md)，將 Epic 資料夾以 `mv`（嚴禁 `cp`）搬入 `8-Archived/`，並比照規範建立 summary（涵蓋主題層成果與各子 spec 的歸檔摘要連結）。
3. 驗證 `0-Epics/` 已無該 Epic 殘留。

`0-Epics/` 只留活躍主題。

---

## 📋 常見情境對照表

| 情境 | 操作方式 |
|------|----------|
| 既有多個 spec（不論階段）→ 事後收成大主題 | 建 Epic ＋ 各子 spec 加 RELATIONS.md ＋ OVERVIEW 登記。不搬檔。 |
| 既有 spec 已有口頭約定的先後順序 | 掛入時把順序轉正成 RELATIONS.md 前置宣告。 |
| 從零開始建大主題 | 先建 Epic 或先建 spec 皆可；建 spec 時直接掛入。 |
| 後面的 spec 要先寫規格 | 允許。實作被 3-Progressing 硬閘門擋到前置完成。 |
| Epic 已存在 → 新 spec 併入 | 建 spec 時掛入，或事後掛入既有 spec。 |
| 子 spec 退出／整個主題解散 | 純文件操作，見生命週期。 |
| A 主題的 spec 依賴 B 主題的 spec | 依賴可跨 Epic，直接在 RELATIONS.md 宣告前置。 |
| 兩個 Epic 搶同一個 spec | 單一歸屬＋停下人工裁決（轉移／改用依賴／拆新 spec）。 |
| 前置 spec 已歸檔 | `8-Archived/` 視為「已滿足」，閘門放行。 |
| 同一 Epic 內平等與有順序的子題混合 | 順序是各子 spec 自己的屬性（有無前置），自然混合。 |

---

## 📚 相關文件

- [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md) — 編號、引用、Stage Entry Gate（含依賴檢查）、OVERVIEW 同步
- [.epic-overview-template.md](.epic-overview-template.md) — EPIC_OVERVIEW 模板
- [.epic-description-template.md](.epic-description-template.md) — EPIC_DESCRIPTION 模板
- [../1-Specs/.spec-relations-template.md](../1-Specs/.spec-relations-template.md) — RELATIONS 模板
- [../1-Specs/SPECS_RULES.md](../1-Specs/SPECS_RULES.md) — 建 spec 時的歸屬與前置問答
- [../8-Archived/ARCHIVED_RULES.md](../8-Archived/ARCHIVED_RULES.md) — Epic 收場歸檔比照規範
