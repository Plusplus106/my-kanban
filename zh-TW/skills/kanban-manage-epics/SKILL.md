---
name: kanban-manage-epics
description: 管理 Epic（大主題）層的完整生命週期：建立 epic、掛入／退出／轉移既有 spec、宣告 spec 間前置依賴、同步狀態彙總、解散與收場歸檔。Epic 採引用型索引，絕不搬動子 spec 檔案。支援可用數字回答的固定問答流程。
version: 1.0.1
last_updated: 2026-09-03
effective_date: 2026-09-03
---

# Kanban Manage Epics

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

處理「多個 spec 收納在一個大主題（Epic）下」與「spec 之間有實作先後依賴」兩種情境的管理操作。本 skill 只管 Epic 生命週期與關聯宣告，**不建立 spec 內容、不推進任何 spec 的階段**（那些分別是建卡類與推進類 skill 的職責）。

## 核心設計原則（本 skill 一切操作的前提）

1. **Epic 是引用型索引，不是容器**：子 spec 永遠留在自己所在的階段資料夾（`1-Specs/` ～ `8-Archived/`），Epic 只登記引用。任何操作都**不得搬動子 spec 的檔案或資料夾**。
2. **依賴是 spec 自己的基礎欄位**：前置宣告寫在各 spec 的 `RELATIONS.md`，不需要先有 Epic 才能宣告；依賴可以跨 Epic。
3. **單一歸屬**：一個 spec 最多屬於一個 Epic。跨 Epic 的需求一律改走前置依賴宣告，不得雙重歸屬。
4. **層級只有一層**：Epic 底下只能掛 spec，不支援 Epic 掛 Epic（巢狀）。
5. **內容分層判準**：只跟單一子 spec 有關的內容，不得寫進 Epic 文件，一律下放該子 spec。Epic 文件只寫「跨子題」的內容，避免雙重真實來源。
6. **依賴閘門語意**（供其他 skill 引用的統一定義）：
   - 建卡（1-Specs）：不擋。前置未完成也可以先寫規格。
   - 拆 plan（2-Plans）：警告不阻擋。提示「前置尚未完成，plan 細節可能過時」。
   - 進 3-Progressing：**硬閘門**。所有前置 spec 必須已在 `7-Done/` 或 `8-Archived/`（已歸檔＝已滿足），否則停下回報；使用者明示覆寫才放行，且必須在該 spec 的 `RELATIONS.md` 覆寫記錄區留下記錄。

## 快速使用範例

- 觸發：`$kanban-manage-epics`
- 回覆：可直接用數字選項（例如 `1`、`2`）。

## 互動問答流程（可用數字回答，一次只問一題）

1. 操作類型

```
請選擇要執行的操作：
1. 建立新 Epic
2. 掛入既有 spec 到 Epic
3. 宣告／修改 spec 的前置依賴
4. spec 退出 Epic
5. spec 轉移到另一個 Epic
6. 檢視／同步 Epic 狀態彙總
7. 解散 Epic
8. 收場歸檔 Epic（搬入 8-Archived）
```

2. 依所選操作追問必要資訊（見各操作流程；若使用者觸發時已提供足夠上下文，可直接推斷，不重複詢問已知資訊）。常見追問：

- kanban 專案根路徑（例如：`my-repos-kanban/ai-fridge-app-be/`）
- Epic 主題名稱與說明（操作 1）／既有 Epic 編號或路徑（操作 2、4～8）
- 目標 spec 的路徑或編號（操作 2～5）

## 參考規範

- `templates/COMMON_CONVENTIONS.md`（編號規則、引用格式、Stage Entry Gate 依賴閘門、EPIC_OVERVIEW 同步規範）
- `templates/0-Epics/EPICS_RULES.md`（**Epic 層最終真相來源**；與本文件衝突時以其為準）
- `templates/0-Epics/.epic-overview-template.md`、`templates/0-Epics/.epic-description-template.md`
- `templates/1-Specs/.spec-relations-template.md`
- `templates/1-Specs/SPECS_RULES.md`
- `templates/8-Archived/ARCHIVED_RULES.md`、`templates/8-Archived/.archived-summary-template.md`（操作 8 用）

## 🔴 首要鐵律（不可違反）

> **寫入類操作分兩種確認模式，缺一不可：**
>
> - **建立類（操作 1）**：先完整建立 Epic 資料夾與所有必備文件，建立完成後**立即停下**，回報所有已建立的路徑清單，等待使用者回覆「同意」或「繼續」。未收到明確確認前，絕對不可自行推進任何後續步驟。
> - **修改／搬移類（操作 2、3、4、5、7、8）**：動手前**先列出將變更的檔案清單與變更內容摘要**，等待使用者確認後才執行；執行完成後再回報實際變更結果。
>
> **🚨 覆蓋指令防護（絕對強制）：即使使用者同時提供了完整需求並附上「直接做」、「不用確認」等任何形式的跨過指令，也不得跨過上述確認步驟。**

## 🔴 引用型鐵律（不可違反）

> 1. **絕對不得搬動任何子 spec 的檔案或資料夾**。本 skill 唯一允許的檔案搬移是操作 8 搬移 Epic 資料夾本身。
> 2. 對子 spec 資料夾，**唯一允許新增或修改的檔案是 `[spec-xxxxx]-RELATIONS.md`**；不得動子 spec 的其他任何文件。
> 3. **絕對不得推進任何 spec 的階段**（不移動、不改狀態欄位）。
> 4. 已在 `8-Archived/` 的 spec 掛入 Epic 時，**不建立也不修改其 RELATIONS.md**（歸檔內容不可變動），僅在 Epic 的 `EPIC_OVERVIEW.md` 單向登記，並於備註標明「已歸檔，僅單向登記」。

## 🔴 歸屬衝突鐵律（不可違反）

> 掛入（操作 2）或轉移（操作 5）前，必須先讀取目標 spec 的 `RELATIONS.md`「所屬 Epic」欄位：
>
> - 欄位為空或檔案不存在 → 可直接掛入（雙向登記）。
> - 欄位已寫著另一個 Epic → **立刻停下，不得自動處理**，向使用者呈現三個選項並等待裁決：
>   1. **轉移**：從原 Epic 移除、改掛新 Epic（兩邊 OVERVIEW 都更新）。
>   2. **改用依賴**：不改變歸屬，改為在需求方 spec 宣告前置依賴。
>   3. **拆新 spec**：新 Epic 需要的其實是另一件事，建議另立新卡（引導使用者改用建卡類 skill）。

---

## 文件格式定義（速查摘要；最終真相來源為 `templates/0-Epics/` 的 RULES 與模板，衝突時以範本為準）

### A. Epic 資料夾結構與命名

```
0-Epics/[YYYY-MM-DD]-[epic-xxxxx]-[theme-name]/
  ├── [epic-xxxxx]-EPIC_OVERVIEW.md      ← 必備：子 spec 索引＋依賴順序＋狀態彙總
  ├── [epic-xxxxx]-EPIC_DESCRIPTION.md   ← 必備：主題層問題陳述、目標、成功指標、範圍界定
  ├── [epic-xxxxx]-ROADMAP.md            ← 選擇性：子題拆分邏輯、順序理由、里程碑
  ├── [epic-xxxxx]-ARCHITECTURE.md       ← 選擇性：跨子題整體架構全景
  ├── [epic-xxxxx]-DECISION_LOG.md       ← 選擇性：主題層決策記錄
  └── [epic-xxxxx]-SCOPE_BOUNDARY.md     ← 選擇性：子題間邊界劃分
```

- `0-Epics/` 位於 kanban 專案根目錄，與 `1-Specs/` ～ `8-Archived/` 平行；若不存在，於操作 1 時建立。
- 日期為 Epic 成立日期；`theme-name` 使用小寫英文、單字間以 `-` 連接。
- `[epic-xxxxx]` 編號：5 碼，由英文大小寫與數字隨機組成（同 `COMMON_CONVENTIONS.md` 編號規則）；同一 Epic 資料夾內所有文件使用相同編號。
- 引用格式：文件中提及 Epic 時寫 `[epic-xxxxx]`，比照 `[spec-xxxxx]` 慣例。

### B. `[epic-xxxxx]-EPIC_OVERVIEW.md`（必備）

```markdown
# [epic-xxxxx] {主題名稱} - Epic Overview

**建立日期：** YYYY-MM-DD
**狀態：** 進行中 (Active)｜已完結待歸檔 (Completed)｜已歸檔 (Archived)
**最後更新：** YYYY-MM-DD HH:mm

## 📋 子 Spec 索引與狀態彙總

| 順序 | Spec 編號 | 名稱 | 前置 | 目前階段 | 備註 |
|------|-----------|------|------|----------|------|
| 1 | [spec-aaaaa] | feature-a | 無 | 8-Archived | |
| 2 | [spec-bbbbb] | feature-b | [spec-aaaaa] | 1-Specs | 規格先行，實作待前置完成 |
| 3 | [spec-ccccc] | feature-c | 無 | 1-Specs | 獨立子題 |

**統計：** 共 3 個子 spec｜已歸檔 1｜進行中 0｜規格階段 2

## 🔀 依賴順序（文字圖）

- [spec-aaaaa] → [spec-bbbbb]（b 依賴 a 的成果，實作順序不可反）
- [spec-ccccc]：獨立，無依賴

## 📁 子 Spec 位置索引

- [spec-aaaaa] → `{專案}/8-Archived/{歸檔資料夾}/`
- [spec-bbbbb] → `{專案}/1-Specs/{spec 資料夾}/`
```

- 「目前階段」與「位置索引」在子 spec 每次跨階段移動時同步更新（見同步規範）。
- 使用者只看這一份，就能掌握整個主題的推進狀態。

### C. `[epic-xxxxx]-EPIC_DESCRIPTION.md`（必備）

```markdown
# [epic-xxxxx] {主題名稱} - Epic Description

**建立日期：** YYYY-MM-DD

## 🎯 主題層問題陳述

（為什麼有這個大主題、要解決什麼整體問題）

## 📋 範圍界定

### 包含的子題方向
- （子題劃分的整體邏輯；個別子題細節寫在各子 spec，不在此展開）

### 不包含
- （明確排除的方向）

## ✅ 主題層成功指標

- （整個主題完成時的整體驗收標準）
```

### D. `[spec-xxxxx]-RELATIONS.md`（子 spec 關聯檔）

放在該 spec 資料夾內、與其他 spec 文件同層，使用同一個 spec 編號前綴。**沒有任何關聯的 spec 不建此檔。**

```markdown
# [spec-xxxxx] 關聯宣告 (Relations)

**最後更新：** YYYY-MM-DD HH:mm

## 🏷️ 所屬 Epic（單值，最多一項；本欄位是歸屬的唯一權威來源）

- [epic-yyyyy] {主題名稱}

## ⛓️ 前置 Spec（實作順序依賴；進 3-Progressing 前必須全數已在 7-Done/8-Archived）

- [spec-zzzzz] {名稱} — 依賴理由：（一句話說明依賴什麼成果）

## 🔓 覆寫記錄（依賴閘門人工放行時填寫，預設空白）

- （範例）YYYY-MM-DD 使用者明示放行進入 3-Progressing，理由：…
```

- 「所屬 Epic」區塊**最多只能有一個** `[epic-` 項目；機械檢查發現多於一項即為資料損壞，停下回報。
- 無歸屬或無前置時，該區塊寫「無」。

### E. EPIC_OVERVIEW 同步規範（比照 PLAN_OVERVIEW 同步規範）

任何 spec 跨階段移動時，若其 `RELATIONS.md` 有所屬 Epic，執行移動的一方（推進類 skill 或手動流程）必須同步更新該 Epic 的 `EPIC_OVERVIEW.md`：目前階段、位置索引、統計、最後更新時間。本 skill 的操作 6 可隨時重建彙總（自我修復用）。

---

## 各操作流程

### 操作 1：建立新 Epic

1. 追問：kanban 專案根路徑、主題名稱（英文 theme-name＋中文說明）、主題層問題陳述與目標。
2. 產生 5 碼 `[epic-xxxxx]` 編號；`0-Epics/` 不存在則先建立。
3. 建立 Epic 資料夾與兩個必備文件（依「文件格式定義」B、C）；選擇性文件視使用者提供的內容決定，不強制。
4. 詢問是否立刻掛入既有 spec（可多個）；若是，逐一執行操作 2 的流程（含衝突檢查）。
5. 【強制停頓】回報所有已建立的路徑清單，等待使用者確認。

### 操作 2：掛入既有 spec 到 Epic

1. 追問：Epic 編號或路徑、目標 spec 路徑（可在任何階段資料夾）。
2. 讀取目標 spec 的 `RELATIONS.md`，執行歸屬衝突鐵律檢查。
3. 【強制停頓】列出將變更的檔案（spec 的 RELATIONS.md 新增或更新＋Epic 的 EPIC_OVERVIEW.md），等確認。
4. 執行雙向登記：
   - spec 側：建立或更新 `RELATIONS.md` 的「所屬 Epic」欄位（已歸檔的 spec 適用引用型鐵律第 4 條，僅單向登記）。
   - Epic 側：`EPIC_OVERVIEW.md` 索引表新增一列（含目前階段與位置）、更新統計與最後更新時間。
5. 回報實際變更結果。

### 操作 3：宣告／修改 spec 的前置依賴

1. 追問：目標 spec 路徑、前置 spec 編號（可多個，可跨 Epic）、每筆的依賴理由。
2. 檢查：前置 spec 必須實際存在（掃描各階段資料夾與 `8-Archived/`）；禁止自我依賴；偵測到循環依賴（A→B→A）時停下回報。
3. 【強制停頓】列出將變更的檔案與內容摘要，等確認。
4. 建立或更新目標 spec 的 `RELATIONS.md`「前置 Spec」區塊；若目標 spec 有所屬 Epic，同步更新該 Epic 的 EPIC_OVERVIEW 依賴順序與索引表「前置」欄。
5. 回報實際變更結果。

### 操作 4：spec 退出 Epic

1. 追問：目標 spec 路徑、退出原因（記入 Epic 的 DECISION_LOG，若無此檔則記入 OVERVIEW 備註）。
2. 【強制停頓】列出將變更的檔案，等確認。
3. spec 側：`RELATIONS.md` 所屬 Epic 改為「無」（前置宣告保留，依賴與歸屬互不影響）；Epic 側：自索引表移除、更新統計。
4. 回報實際變更結果。

### 操作 5：spec 轉移到另一個 Epic

1. 追問：目標 spec 路徑、目標 Epic。
2. 依歸屬衝突鐵律確認使用者裁決為「轉移」後：原 Epic 移除登記 → 新 Epic 加入登記 → spec 的 `RELATIONS.md` 改寫所屬 Epic，三處一次完成。
3. 【強制停頓】動手前列變更清單等確認；完成後回報。

### 操作 6：檢視／同步 Epic 狀態彙總

1. 追問：Epic 編號或路徑（或選「全部 Epic」）。
2. 掃描該專案 `1-Specs/` ～ `8-Archived/` 各階段，找出索引表中每個子 spec 的實際所在階段與路徑。
3. 比對 `EPIC_OVERVIEW.md` 記載，列出落差（階段不符、位置不符、統計錯誤、RELATIONS 與索引表不一致）。
4. 若有落差：【強制停頓】列出將修正的內容等確認後，更新 OVERVIEW（以實際檔案位置為準；RELATIONS 與索引表衝突時，以 RELATIONS 的歸屬欄位為權威來源）。
5. 若無落差：回報「彙總與實際狀態一致」，不做任何寫入。

### 操作 7：解散 Epic

1. 追問：Epic 編號或路徑、解散原因。
2. 前提檢查：向使用者確認解散意圖（子 spec 全部回歸獨立，不影響任何子 spec 的階段與內容）。
3. 【強制停頓】列出將變更的檔案：所有子 spec 的 `RELATIONS.md` 所屬 Epic 改「無」（已歸檔的除外）＋ Epic 資料夾處置方式（預設整個資料夾刪除前先詢問使用者：刪除，或保留並於 OVERVIEW 標記「已解散」）。
4. 依使用者選擇執行後回報。

### 操作 8：收場歸檔 Epic

1. 前提檢查（缺一不可，缺任一項停下回報）：
   - 索引表中**所有**子 spec 的實際位置皆已在 `8-Archived/`（以掃描結果為準，不信任 OVERVIEW 記載——先跑一次操作 6 的比對）。
   - 使用者明示確認要收場歸檔。
2. 歸檔前更新：`EPIC_OVERVIEW.md` 狀態改「已歸檔 (Archived)」、位置索引全數補上各子 spec 的最終歸檔路徑。
3. 讀取 `templates/8-Archived/ARCHIVED_RULES.md` 與 `.archived-summary-template.md`，將 Epic 資料夾以 `mv`（嚴禁 `cp`）搬入 `8-Archived/`，並比照規範建立 summary（summary 需涵蓋主題層成果與各子 spec 的歸檔摘要連結）。
4. 驗證來源 `0-Epics/` 已無該 Epic 殘留後，回報歸檔結果與 summary 路徑。

---

## 與其他 kanban skill 的分工（本 skill 不做的事）

| 事項 | 負責者 |
|------|--------|
| 建立 spec 內容（問答收集需求、IDEA_DESCRIPTION 等） | kanban-create-specs-*（未來版本會在問答中加「是否屬於某個 Epic？有無前置 spec？」，有則呼叫本 skill 的登記邏輯） |
| 拆 plan 時的前置未完成警告 | 拆解類 skill（*-breakdown-to-plans 等） |
| 進 3-Progressing 的依賴硬閘門檢查 | 推進類 skill（*-push-to-archived 等），依本文件「依賴閘門語意」執行 |
| spec 跨階段時的 EPIC_OVERVIEW 同步 | 執行移動的推進類 skill；本 skill 操作 6 作為自我修復 |
| spec 歸檔時偵測「Epic 最後一個子 spec」並提示可收場 | kanban-archive-only 與推進類 skill（提示後仍須使用者明示才執行操作 8） |

> ⚠️ 上表中其他 skill 的整合改動尚未實施；實施前，相關檢查與同步由使用者觸發本 skill 的操作 6 補位。

## 禁止事項

- **絕對不得**搬動、改名、修改任何子 spec 的檔案（唯一例外：`RELATIONS.md`）。
- **絕對不得**推進任何 spec 的階段或修改其狀態欄位。
- **絕對不得**在歸屬衝突時自動選邊，必須停下等使用者裁決。
- **絕對不得**讓一個 spec 同時屬於兩個 Epic，或建立 Epic 掛 Epic 的巢狀結構。
- **絕對不得**把單一子 spec 的實作細節寫進 Epic 文件（內容分層判準）。
- **絕對不得**未經使用者明示確認就執行操作 7（解散）與操作 8（收場歸檔）。
