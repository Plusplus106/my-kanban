---
name: kanban-create-testing-then-push-to-archived
description: 從 Testing 階段開始，建立 testing 文件後立即完成測試驗證，再自動推進到 Done 與 Archived。適用於已完成開發、要快速完成驗證與歸檔的情境。
version: 2.0.0
last_updated: 2026-05-16
effective_date: 2026-05-16
---

# Kanban Create Testing Then Push To Archived

## 🔴🔴🔴 工作主從鐵律（最高優先級，凌駕一切其他規則）

> **本 Skill 的工作有「主」與「從」之分，永遠不可顛倒：**
>
> ### 🥇 主要工作（90% 比重，是真正交付的內容）
>
> 1. **實際撰寫專案程式碼**：依 spec 與 plan 的需求，在專案實際的 `src/`、`lib/`、`app/` 等目錄下新增/修改/刪除程式碼
> 2. **實際撰寫測試程式碼**：在專案實際的 `tests/`、`__tests__/`、`spec/` 等目錄下新增/修改測試檔
> 3. **實際執行測試指令**：跑 `npm test`、`pytest`、`yarn jest` 等專案實際測試指令，確認 all green
> 4. **實際更新專案文件**：README、`docs/`、API 文件等隨功能變動同步更新
>
> ### 🥈 次要工作（10% 比重，只是輔助記錄）
>
> 5. **kanban 任務文件的內容更新**：填欄位、勾 checkbox、寫測試結果摘要
> 6. **kanban 資料夾與檔案搬移**：跨階段 `mv`、建子資料夾、清理殘留
>
> ### ❌ 絕對禁止的錯誤理解
>
> - ❌ 把「處理任務」理解成「只搬 markdown 檔案 + 改 markdown 內容 + 寫 summary」
> - ❌ 認為「資料夾結構正確 + 狀態欄位正確 + summary 寫好 = 任務完成」
> - ❌ 在沒有實際撰寫專案程式碼、測試程式碼、執行測試的情況下，就把 kanban 文件推到 `7-Done/` 或 `8-Archived/`
> - ❌ 把「執行 `mv` 與更新 markdown」當作「主要交付物」
>
> ### ✅ 正確理解
>
> - ✅ kanban 文件的階段轉換**僅僅是「實作進度的記錄」**，不是「工作本身」
> - ✅ 每一個 kanban 任務文件背後，都必須對應到**實際的專案程式碼變動**
> - ✅ 沒有實際的 `git diff`（程式碼變動）、沒有實際的測試輸出，就**禁止**把任務推進到 `7-Done/` 或 `8-Archived/`
> - ✅ 寧可把 kanban 任務留在 `3-Progressing/` 或 `4-Testing/` 等待補實作，也不可在沒實作的狀況下把它推進到 done/archived
>
> ### 🚨 違規警報
>
> 若使用者在歸檔後檢查發現「kanban 文件已歸檔但專案程式碼根本沒動」，視為**最嚴重的違規**，等同欺騙使用者。本 Skill 為防止此類違規，在每個階段都加入「實作證據檢查」（見下方各階段強制規則與「🔴 歸檔前強制輸出檢查清單」Step D-2）。

## 路徑基準

本文件中提到的 `templates/`、`scripts/`、`promps/`、`skills/`，皆以目前語系內容根目錄為相對基準（例如 `zh-TW/`），不綁定 repo 根目錄固定路徑。

## 目的

從 `4-Testing` 開始，建立 testing 文件後立即執行測試與驗證；通過後自動推進到 `7-Done` 與 `8-Archived`。

## 快速使用範例

- 觸發：`$kanban-create-testing-then-push-to-archived`
- 回覆：可直接用數字選項（例如 `1`、`2`、`3`）。

## 互動問答流程（可用數字回答）

1. 目的地路徑

- 請輸入要建立 Testing 文件的目的地路徑（例如：`my-project/4-Testing/`）

2. 測試內容摘要

- 一行描述測試目標與驗收重點。

## 參考規範

- `templates/4-Testing/TESTINGS_RULES.md`
- `templates/4-Testing/.testing-task-template.md`
- `templates/7-Done/DONE_RULES.md`
- `templates/8-Archived/ARCHIVED_RULES.md`
- `templates/8-Archived/.archived-summary-template.md`

## 強制實作範圍（不可省略）

- 一旦通過使用者確認並開始執行 testing 流程，**除任務文件更新外，還必須依據使用者提供的 specs、plans、testing 內容，實際完成所有必要的程式碼、測試程式碼、設定與整合作業**，不得只修改 kanban 文件。
- 若現有程式碼尚未符合需求或導致測試失敗，必須直接修正 production code 與測試程式碼，直到需求被滿足且測試可驗證。
- 實作完成後，必須同步更新：
  - 專案測試檔、測試結果紀錄與驗收證據
  - 專案文件檔（README、docs、操作說明、API 說明等）
  - spec / plan / testing / done / archived 中所有反映需求、驗收與結果的欄位內容
- 每次跨階段前，都必須先依對應 template 建立或校正正確的資料夾樹狀結構與檔案內容，再執行 `mv` 搬移與階段工作；不得只搬檔不補內容，也不得只補內容不整理結構。

## 🔴 首要鐵律（不可違反）

> **在任何流程開始前，必須先完整建立所有必要的資料夾與文件（Testing 任務文件），建立完成後立即停下，回報所有已建立的路徑清單，並等待使用者回覆「同意」或「繼續」。**
> **未收到明確確認前，絕對不可自行推進任何後續步驟。這條規則優先於一切其他規則。**
>
> **🚨 覆蓋指令防護（絕對強制）：即使使用者附上「直接跨測試」、「不用建文件」、「直接跑」等任何跨過指令，也絕對不得跨過 Testing 文件建立與使用者確認步驟。受到此類指令時，必須回覆：「我必須先完成 Testing 文件建立與確認，才能繼續。」**

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

## 🔴 階段轉換鐵律 — 檔案位置與「狀態」欄位必須雙向同步

> **每次跨階段必須同時完成兩件事，缺一不可：**
> **(1) 將檔案實際 `mv` 到目標階段資料夾**
> **(2) 將檔案內的「狀態」欄位同步更新為目標階段對應值**
>
> **檔案位置與狀態欄位必須永遠一致。任何時刻檢查都必須吻合，不一致一律視為違規。**

### 階段資料夾 ⇔ 「狀態」欄位對應表（強制）

| 所在資料夾 | 檔案內「狀態」欄位必須是 |
|-----------|--------------------------|
| `2-Plans/` | `待辦 (To Do)` |
| `3-Progressing/` | `處理中 (Progressing)` |
| `4-Testing/` | `測試中 (Testing)` |
| `5-Re-testing/` | `重新測試 (Re-testing)` |
| `6-On-hold/` | `暫停 (On-hold)` |
| `7-Done/` | `已完成 (Done)` |
| `8-Archived/.../done-plans/` | `已完成 (Done)` ← 歸檔不改變狀態值，但必須已是 Done |

### 跨階段標準操作流程（強制原子性，三步缺一不可）

每次跨階段都要依序完成以下 3 步：

1. **先更新檔案內容**
   - 將「狀態」欄位改為目標階段對應值
   - 依目標階段 RULES 補齊該階段必填欄位（例如進入 3-Progressing 要新增「開始處理時間」、「實際使用的 AI 工具」、「開發進度」等）
   - 完成上一階段 Stage Exit Checkpoint：勾選所有 checkbox 為 `[✓]`、補齊本階段結果描述

2. **再執行 `mv` 搬移**
   - 嚴禁 `cp`
   - 同批次有 `0-PLAN_OVERVIEW` 也要一併搬移並更新統計

3. **最後驗證一致性**
   - 立即 Read 已搬移的檔案，確認「狀態」欄位顯示的階段名稱 = 檔案目前所在資料夾名稱
   - 不一致必須立即修正後才可繼續下一個動作

### 歸檔前的強制狀態檢查（絕對不可跳過）

進入 `8-Archived` 之前，**必須**對所有準備歸檔的 plan 文件逐一檢查：

1. 檔案目前是否真的在 `7-Done/` 資料夾下（不在的話必須先把該檔案完整跑完該階段流程，禁止跳階段直接歸檔）
2. 檔案內「狀態」欄位的值是否為「已完成 (Done)」
3. 若狀態欄位不是「已完成 (Done)」，**禁止歸檔**，必須回到對應階段補完流程後再歸檔

**驗證指令（強制執行，且結果必須全部通過）：**

```bash
# 檢查所有準備歸檔的文件，狀態欄位是否都是「已完成 (Done)」
for f in <project>/7-Done/YYYY-MM-DD-[spec-xxxxx]-feature-name/*.md; do
  status=$(grep -m1 "^\*\*狀態" "$f")
  if ! echo "$status" | grep -q "已完成 (Done)"; then
    echo "❌ 違規檔案：$f"
    echo "   目前狀態：$status"
  fi
done
```

任一檔案違規時，立即停止歸檔流程、修正狀態欄位、重跑驗證指令直到全部通過，才可繼續歸檔。

## 🔴 歸檔前強制輸出檢查清單（最高優先級，必須在對話中完整輸出，缺一視為違規）

> **背景：** 過往 AI 經常聲稱「已參考 ARCHIVED_RULES.md」但實際結構錯誤（例如檔案平鋪、summary 命名錯誤、來源未清理）。為徹底杜絕此問題，本 Skill 規定：**進入 `8-Archived` 前，必須在對話中逐項完整輸出以下 6 步檢查內容，每一步都要有具體可驗證的輸出，禁止省略、合併或只說「已完成」。**
>
> **此清單是強制性的對話輸出義務，不是內部執行步驟。使用者必須能在對話中親眼看到每一步的輸出。**

### Step A：引用宣告（必須照下方格式輸出）

在對話中輸出以下三行（替換實際路徑與行號）：

```
[歸檔前置作業]
✅ 已 Read templates/8-Archived/ARCHIVED_RULES.md（共 N 行）
✅ 已 Read templates/8-Archived/.archived-summary-template.md（共 N 行）
✅ 將依 ARCHIVED_RULES.md 第「📁 標準歸檔結構」章節範例建立目錄
```

### Step B：來源檔案清單（必須輸出實際 ls 結果）

執行並輸出以下指令的實際結果：

```bash
ls -la <project>/1-Specs/YYYY-MM-DD-[spec-xxxxx]-feature-name/
ls -la <project>/7-Done/YYYY-MM-DD-[spec-xxxxx]-feature-name/
```

### Step C：狀態欄位驗證（必須輸出實際指令結果）

執行並輸出「歸檔前的強制狀態檢查」驗證指令的實際結果。若有違規檔案必須先修正再回到 Step A 重來，禁止跳過此步驟。

### Step C-2：實作證據檢查（最高優先級，禁止用空話帶過）

**此步驟用於防止「kanban 文件已歸檔但專案程式碼根本沒動」的違規。必須在對話中逐項輸出實際證據，缺一視為違規。**

#### C-2.1：列出本次實作涉及的所有專案程式碼檔案

執行並輸出（取代 `<project-root>` 為實際專案根目錄、`<since-time>` 為任務開始時間）：

```bash
# 列出本次任務新增/修改的程式碼檔案（非 kanban 檔）
git -C <project-root> status --short | grep -v "kanban/"
git -C <project-root> diff --name-only HEAD~N HEAD | grep -v "kanban/"
```

或若無 git，列出所有實際變動的程式碼檔案路徑（一行一個）。

**自我檢查（必須在輸出後立即回答）：**
- ❓ 上述清單是否包含**至少一個** `src/`、`lib/`、`app/`、或專案實際程式碼目錄下的檔案？
- ❓ 若清單只有 kanban 檔案（`*.md` 在 kanban 目錄下），代表**根本沒做實作工作**，必須立即停止歸檔，回到 `3-Progressing/` 補做實作。

#### C-2.2：列出本次撰寫的測試程式碼檔案

執行並輸出：

```bash
git -C <project-root> status --short | grep -E "test|spec|__tests__" | grep -v "kanban/"
git -C <project-root> diff --name-only HEAD~N HEAD | grep -E "test|spec|__tests__" | grep -v "kanban/"
```

**自我檢查：**
- ❓ 是否包含**至少一個**測試檔案的新增或修改？
- ❓ 若沒有任何測試檔變動，必須立即停止歸檔，回到 `4-Testing/` 補做測試。

#### C-2.3：貼出最後一次測試執行的完整輸出

必須在對話中貼出本次任務最後一次執行測試的**完整終端輸出**，包含：

- 實際執行的測試指令（例如 `npm test`、`pytest -v`）
- 測試框架輸出的測試案例清單與結果
- 最終統計（passed / failed / total）

**自我檢查：**
- ❓ 輸出中是否顯示「all tests passed」或等價的全綠結果？
- ❓ 若無實際測試輸出，或測試有失敗，**禁止歸檔**，必須回到 `4-Testing/` 或 `5-Re-testing/` 補完。
- ❓ 若任務文件「測試結果」區塊是空的或只寫摘要，視為違規。

#### C-2.4：交叉比對 kanban 任務文件與實作

對於每一份準備歸檔的 plan 任務文件：

- ❓ 文件中「相關程式碼檔案」欄位列出的路徑，是否與 C-2.1 的清單對得上？
- ❓ 文件中「測試程式碼檔案」欄位列出的路徑，是否與 C-2.2 的清單對得上？
- ❓ 文件中「測試結果」區塊的指令與輸出，是否與 C-2.3 的實際輸出一致？

任一項對不上，代表 kanban 文件描述與實際實作脫節，**禁止歸檔**，必須先補對應內容。

### Step D：宣告目標結構（必須輸出完整目錄樹）

在對話中輸出本次歸檔將建立的完整目標結構，並逐檔說明搬移對應關係。範例輸出格式：

```text
[歸檔目標結構宣告]
8-Archived/2026-05-16-[spec-Qt9p1]-quota-reset-on-tier-change/
├── 1-Specs/
│   ├── [spec-Qt9p1]-IDEA_DESCRIPTION.md         ← 來自 1-Specs/.../[spec-Qt9p1]-IDEA_DESCRIPTION.md
│   └── [spec-Qt9p1]-CLEANUP_AND_INTEGRATION.md  ← 來自 1-Specs/.../[spec-Qt9p1]-CLEANUP_AND_INTEGRATION.md
├── done-plans/
│   ├── 0-PLAN_OVERVIEW.md                       ← 來自 7-Done/.../0-PLAN_OVERVIEW.md
│   ├── 2026-05-16-[spec-Qt9p1]-1-2-high-[plan-Lm3r7]-...md  ← 來自 7-Done/...
│   └── 2026-05-16-[spec-Qt9p1]-2-2-high-[plan-Pw8k2]-...md  ← 來自 7-Done/...
└── [spec-Qt9p1]-summary.md                       ← 新建（依 .archived-summary-template.md）
```

**Step D 自我審查（必須在輸出後立即檢查）：**
- ❓ summary 檔名是否為 `[spec-xxxxx]-summary.md`？（不是 `ARCHIVED_SUMMARY.md` 等變體）
- ❓ 是否有 `1-Specs/` 與 `done-plans/` 兩個子資料夾？
- ❓ 是否所有檔案都歸位到子資料夾，沒有平鋪在根目錄？
- ❓ 根資料夾是否使用 `[spec-xxxxx]` 而非 `[plan-xxxxx]`？

任一答案為「否」，必須立即修正宣告後重來。

### Step E：執行 mkdir + mv（必須逐個指令輸出）

依 Step D 宣告依序執行 `mkdir -p` 與 `mv` 指令。每個指令都必須在對話中可見，不得用一個 `&&` 串起來掩蓋細節。

### Step F：執行收斂驗證（必須輸出實際指令結果）

執行並輸出以下兩組指令的實際結果：

```bash
# 驗證 1：歸檔結構完整
ls -R <project>/8-Archived/YYYY-MM-DD-[spec-xxxxx]-feature-name/

# 驗證 2：來源無殘留
find <project>/{1-Specs,2-Plans,3-Progressing,4-Testing,5-Re-testing,6-On-hold,7-Done} \
  -type f -name "*[spec-xxxxx]*" 2>/dev/null
```

驗證 1 結果必須符合 Step D 宣告。
驗證 2 結果必須為空。
任一不符必須立即修正，並重跑驗證指令直到通過。

### Step G：歸檔後最終回頭驗證（強制，禁止省略，禁止與 Step F 合併）

> **此步驟是「自我審計」，目的是抓出 Step A~F 過程中可能漏看或自欺的問題。** 即使 Step F 通過，仍必須執行 Step G 完整的雙重對照。發現任何不一致必須立即修正並重跑此步，直到全部通過才可宣告歸檔完成。

#### G-1：重新 Read 模板，對照歸檔結構（結構對照）

1. **重新 Read** `templates/8-Archived/ARCHIVED_RULES.md`（即使 Step A 已讀過，此處必須再讀一次）
2. **重新 Read** `templates/8-Archived/.archived-summary-template.md`
3. **執行並輸出** `ls -R <project>/8-Archived/YYYY-MM-DD-[spec-xxxxx]-feature-name/` 的實際結果
4. **逐項對照表格**（必須在對話中完整輸出）：

| 規範項目 | 規範來源 | 實際結果 | 是否符合 |
|---------|---------|---------|---------|
| 歸檔根資料夾命名為 `YYYY-MM-DD-[spec-xxxxx]-feature-name/` | ARCHIVED_RULES.md「✅ 命名與結構」 | （填入實際資料夾名） | ✅ / ❌ |
| 含 `1-Specs/` 子資料夾 | ARCHIVED_RULES.md「📁 標準歸檔結構」 | （是 / 否） | ✅ / ❌ |
| 含 `done-plans/` 子資料夾（不是 `done-tasks/`） | 同上 | （是 / 否，實際名稱） | ✅ / ❌ |
| `1-Specs/` 內檔名為 `[spec-xxxxx]-XXX.md` | SPECS_RULES.md | （列出實際檔名） | ✅ / ❌ |
| `done-plans/` 內檔名格式為 `YYYY-MM-DD-[spec-xxxxx]-N-優先級-[plan-yyyyy]-類別-描述.md` | COMMON_CONVENTIONS.md | （列出實際檔名） | ✅ / ❌ |
| summary 檔名為 `[spec-xxxxx]-summary.md`（不是 ARCHIVED_SUMMARY.md 等變體） | ARCHIVED_RULES.md「Summary 檔名」 | （填入實際 summary 檔名） | ✅ / ❌ |
| summary 內容章節完整（依 .archived-summary-template.md 全部章節都在） | .archived-summary-template.md | （列出 summary 章節清單） | ✅ / ❌ |
| 沒有任何檔案平鋪在歸檔根資料夾（除了 summary） | ARCHIVED_RULES.md「禁止事項」 | （列出根目錄檔案） | ✅ / ❌ |
| 來源 7 個階段資料夾無殘留 | ARCHIVED_RULES.md「步驟 7 / 步驟 8」 | （貼 find 指令結果） | ✅ / ❌ |

任一項為 ❌，必須立即修正後重跑 Step G。

#### G-2：重新 Read 每個歸檔檔案，檢查內容與狀態（內容狀態檢查）

對 `8-Archived/YYYY-MM-DD-[spec-xxxxx]-feature-name/` 下的**每一個 .md 檔案**執行以下檢查（不可省略任何一個檔案，不可只抽樣）：

##### G-2.1：plan 任務文件（done-plans/ 下的每一份）

對每一份 plan 任務文件 Read 後，輸出檢查表：

| 檔案 | 「狀態」欄位 | 開發進度全 `[✓]` | 測試進度全 `[✓]` | 「相關程式碼檔案」非空且非 kanban 路徑 | 「測試程式碼檔案」非空 | 「測試結果」區塊含完整指令與輸出 | 完成標記是 `[✓]` 而非 `[x]` |
|------|-------------|----------------|---------------|---------------------------------|-------------------|-------------------------------|---------------------------|
| `xxx-plan-Az4a2-...md` | 必須是「已完成 (Done)」 | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |
| `xxx-plan-By3n1-...md` | ... | ... | ... | ... | ... | ... | ... |

任一欄為 ❌，必須立即補正該檔案後重跑 Step G。

##### G-2.2：0-PLAN_OVERVIEW（若有）

Read overview 後檢查：

- ❓ 「最後更新時間」是否為最新（歸檔當下時間，而非舊時間）？
- ❓ 任務統計是否與實際 done-plans 數量一致？
- ❓ 所有任務狀態是否都標記為「已完成」？
- ❓ 整體進度是否為 100%？

任一項否，補正後重跑 Step G。

##### G-2.3：1-Specs 文件（IDEA_DESCRIPTION、CLEANUP_AND_INTEGRATION 等）

Read 後檢查：

- ❓ 內容是否反映實際完成狀況（而非任務開始時的初始草稿）？
- ❓ 「驗收條件」、「成功指標」等欄位是否更新為實際達成的結果？
- ❓ 若 spec 文件中提到的需求在實作過程有調整，是否已回寫到 spec？

任一項否，補正後重跑 Step G。

##### G-2.4：summary

Read summary 後檢查：

- ❓ 所有章節是否完整（對照 .archived-summary-template.md，缺章節必須補）？
- ❓ 「歸檔時間」是否為實際當下時間？
- ❓ 「總任務數」、「任務分類統計」、「平均測試覆蓋率」、「平均測試成功率」是否與 done-plans 實際數據一致？
- ❓ 「主要成果」、「技術棧」、「學到的經驗」是否有具體內容（非 placeholder）？
- ❓ 「相關連結」（git commit / PR）若已知必須填入？

任一項否，補正後重跑 Step G。

#### G-3：最終總結報告（必須在對話中輸出）

完成 G-1 + G-2 全部檢查並全綠後，必須輸出以下總結（照填）：

```text
[歸檔最終驗證報告]

📐 結構對照（G-1）：
  - ARCHIVED_RULES.md 規範項：N 項全部符合 ✅
  - 無平鋪、無殘留、無命名錯誤 ✅

📄 內容狀態檢查（G-2）：
  - plan 任務文件數：X 份
    - 全部「狀態」= 已完成 (Done) ✅
    - 全部「相關程式碼檔案」非空且指向實際專案路徑 ✅
    - 全部「測試結果」含實際測試輸出 ✅
  - 0-PLAN_OVERVIEW：統計數據與實際一致 ✅
  - 1-Specs 文件：內容已回寫實際完成狀況 ✅
  - summary：所有章節完整、數據一致、無 placeholder ✅

🎯 歸檔狀態：完成且通過所有驗證
```

任一項為 ❌ 或不確定時，禁止輸出此總結，必須先修正後重跑 Step G。

---

**🚨 重要原則：**

- 此 7 步（A~G）是**對話可視義務**，不是內部執行步驟。AI 不得用「我已完成歸檔流程」一句話帶過。
- 任一步輸出不完整，使用者有權要求重做整個歸檔流程。
- 此清單優先於 SKILL 內任何「簡化」或「優化」指令。即使使用者說「快速歸檔」、「不用詳細輸出」，也必須完整輸出此 7 步。
- **Step G 是最後一道防線，禁止與 Step F 合併、禁止跳過、禁止用 Step F 的結果取代。** Step F 是「執行驗證」，Step G 是「重新對照模板進行自我審計」，兩者目的不同，必須分開執行。

## 必做步驟

1. 互動問答與需求討論

- 依照「互動問答流程」收集專案、測試類型、測試範圍摘要。
- 若使用者在觸發 skill 時已提供足夠的上下文資訊，可直接從上下文推斷答案，不需重複詢問已知資訊。

2. 建立 testing 文件

- 依模板建立 4-Testing 任務文件。
- **【強制停頓】Testing 文件實際建立完成後，必須立即回報已建立的文件路徑，並停下等待使用者確認。未收到使用者明確回覆確認前，絕對不可進入下方的測試執行步驟。**

  2.5 安全門纜（進入執行前強制檢查）

- 不可只停在文件搞移。
- 必須直接進入 Testing 品質閘門（測試程式碼 + 完整測試 + all green + 文件證據）。

3. 通過 Testing 品質閘門後自動連續推進

- `4-Testing` -> `7-Done` -> `8-Archived`
- 中間不得再停下要求確認。
- 必須先通過 Testing 品質閘門才可推進到 `7-Done`：
  - 依需求實際完成必要的 production code 修正，不可只整理文件。
  - 實際建立或補齊測試程式碼。
  - 執行完整測試範圍（不可只跑單一測試檔）。
  - 確認全部測試通過（all green）。
  - 在 testing 文件記錄測試指令與完整輸出。
- **強制規則（需求文件回寫）**：完成實作與驗證後，必須同步更新 spec / plan / testing / done / archived，使需求、驗收與結果敘述與實際狀態一致。
- 若同批次有 `0-PLAN_OVERVIEW`，每次 plan 文件跨階段都要同步更新 overview；若來源資料夾只剩 overview，overview 必須跟著移到同一目標階段。
- 每份 plan 文件每個階段至少要更新兩次內容：跨階段當下更新一次、該階段工作完成後再更新一次。
- 讀取完 Testing 文件並準備開始實作時，優先檢查任務清單中可同步開始實作的項目。
- 若任務彼此可並行且無依賴衝突，開啟同步實作模式。
- 若無法同步開始實作，必須依前後依賴關係逐步執行。
- **強制規則（Stage Entry Gate）**：進入新階段時，**必須先完成檔案移動（mv）與任務文件內容/狀態更新**，並確認來源階段無殘留後，**才可開始該階段實作（如寫程式、寫測試等）**。嚴禁 `cp`。
- **強制規則（Stage Exit Checkpoint）**：離開每個階段前，必須先完成所有 checkbox 勾選（`[✓]`）、補齊工作結果描述、更新 PLAN_OVERVIEW。以上三項未完成前，不得執行移動到下一階段。

### 已提供既有文件時的直接續跑規則

- 若使用者提供已建立的 testing 文件（單一、多個、或資料夾），不需要重建 testing，直接從 `4-Testing` 開始，後續推進 `7-Done` -> `8-Archived`。
- 若使用者提供已建立的 plan 文件，必須先確認這些 plan 文件是否已有共同父層資料夾；若尚未建立，必須先建立父層資料夾，再從 `3-Progressing` 開始續跑。無論是單一 plan 文件或多個 plan 文件，都不可省略父層資料夾。
- 若使用者提供已建立的 plan 文件（單一、多個、或資料夾），可直接從 `3-Progressing` 開始，完成後再進入 `4-Testing`，後續推進 `7-Done` -> `8-Archived`。

4. 套用模板與補齊欄位

- 每一階段都必須符合模板。
- 若資訊不足，先填 placeholder，再繼續。

5. 完成後停止

- 到 `8-Archived` 且 summary 建立完成後停止。
- 回報最終輸出路徑與摘要檔路徑。

## 停止條件

- 測試失敗且無法修復時可中止並回報。
- 檔案系統不可寫時可中止並回報。
- 測試未全數通過時，不可推進到 `7-Done` 或 `8-Archived`。

## 專案文件更新（歸檔後自動執行，不中斷）

歸檔完成後，必須自動執行以下流程，除非中斷條件成立，否則全程不停下：

1. **自動尋找專案文件**：根據本次任務涉及的程式碼路徑，自動搜尋專案內的文件資料夾（如 `docs/`、`README.md`、Wiki 等）。
2. **評估是否需要更新**：判斷本次任務變動（功能說明、API 介面、架構設計、操作流程等）是否涉及需要同步更新的文件內容。
3. **自動執行更新**：若需要更新且能找到對應文件，直接更新文件內容，無需中斷。
4. **若找不到文件路徑**：
   - 若確認本次變動需要更新文件，但找不到應更新的路徑 → **中斷，告知使用者需同步更新文件，請提供專案路徑、特定資料夾路徑或文件檔路徑**。
   - 使用者提供路徑後 → 繼續自動執行，不再中斷。
   - 若後續仍有其他文件需更新但又找不到路徑 → 再次中斷請使用者補充路徑，否則繼續自動完成。
5. **若確認無文件存在**：自動建立 `docs/` 資料夾（或單一文件檔），將必要說明寫入後繼續執行，直到結束。
6. **可直接跳過的情況**（不中斷，自動略過，並在最終回報中說明原因）：
   - 找不到任何文件路徑，**且**本次變動確認不涉及任何文件內容的修改
   - 本次任務純粹是系統內部結構調整，無公開行為或說明異動

## 禁止事項

- **絕對不得**在 Testing 文件建立完成並獲得使用者確認前，執行任何測試或推進動作。
- **絕對不得**只搬移文件到 `4-Testing` 就視為 testing 完成。
- **絕對不得**在 testing 階段只更新 kanban 文件而未修正對應程式碼、測試程式碼與專案文件。
- **絕對不得**跳過 Testing 品質閘門直接進入 `7-Done` 或 `8-Archived`。
- **絕對不得**使用 `cp` 複製文件（只能用 `mv`）。
- **絕對不得**未完成 checkpoint 勾選即跨階段移動。
- 測試未全數通過時，不可推進到 `7-Done` 或 `8-Archived`。
- **絕對不得**在進入任一階段前，跳過該階段對應的 RULES / template 檔案閱讀（憑印象產出格式）。
- **絕對不得**將 plan 文件、`0-PLAN_OVERVIEW.md`、spec 文件**平鋪**到 `8-Archived/YYYY-MM-DD-[spec-xxxxx]-feature-name/` 根目錄；**必須**分別放入 `1-Specs/` 與 `done-plans/` 子資料夾。
- **絕對不得**將 archived summary 命名為 `ARCHIVED_SUMMARY.md`、`SUMMARY.md` 或其他變體；**必須**使用 `[spec-xxxxx]-summary.md` 或 `[no-spec]-summary.md`。
- **絕對不得**在歸檔完成後，留下 `1-Specs/`、`2-Plans/`、`3-Progressing/`、`4-Testing/`、`5-Re-testing/`、`6-On-hold/`、`7-Done/` 中該批次 spec 的殘留資料夾或檔案。
- **絕對不得**使用 `[plan-xxxxx]` 作為歸檔根資料夾識別（必須使用 `[spec-xxxxx]` 或 `[no-spec]`）。
- **絕對不得**使用 `done-tasks/` 舊名稱（必須使用 `done-plans/`）。
- **絕對不得**只搬移檔案而不更新檔案內「狀態」欄位；也不得只更新「狀態」欄位而不搬檔案。兩者必須在同一次跨階段操作中同步完成。
- **絕對不得**讓檔案內「狀態」欄位與檔案目前所在資料夾不一致（例如檔案在 `4-Testing/` 卻寫「處理中 (Progressing)」、檔案在 `8-Archived/` 卻寫「測試中 (Testing)」）。
- **絕對不得**將「狀態」欄位不是「已完成 (Done)」的文件搬入 `8-Archived/`。歸檔前必須先跑「歸檔前的強制狀態檢查」驗證指令，確認全數通過。
- **絕對不得**跳階段（例如直接從 `3-Progressing/` 跳到 `7-Done/`，或從 `4-Testing/` 跳到 `8-Archived/`），每個階段都必須依序經過。
- **絕對不得**跳過或簡化「🔴 歸檔前強制輸出檢查清單」的 7 步輸出（A 到 G）。即使使用者要求「快速歸檔」、「不用詳細輸出」，也必須完整輸出 7 步，且每一步都要有具體可驗證的輸出（實際 ls / find / grep 指令結果），不得用「已完成」一句話帶過。
- **絕對不得**跳過或簡化 Step G「歸檔後最終回頭驗證」。Step F 與 Step G 目的不同，禁止合併、禁止用 Step F 取代 Step G。Step G 必須包含：(1) 重新 Read ARCHIVED_RULES.md 並逐項對照表格、(2) Read 每一份歸檔檔案檢查內容與狀態、(3) 輸出最終驗證總結報告。
- **【最嚴重違規】絕對不得**只搬 kanban markdown 檔案、只更新 kanban 文件內容、只寫 summary 就推進到 `7-Done/` 或 `8-Archived/`，而沒有實際撰寫專案程式碼、測試程式碼與執行測試。kanban 文件管理是**次要工作**，實際的程式碼與測試實作才是**主要交付物**。
- **絕對不得**讓 kanban 任務文件的「相關程式碼檔案」、「測試程式碼檔案」、「測試結果」欄位為空或只填 placeholder 就推進到下一階段。這些欄位必須對應到實際的專案程式碼變動，並能通過「🔴 歸檔前強制輸出檢查清單 Step C-2 實作證據檢查」。
- **絕對不得**把「執行 `mv` + 改 markdown 內容」誤解為「完成任務」。任務的真正完成標準是：專案程式碼實作完畢 + 測試程式碼撰寫完畢 + 測試實際執行通過 + 專案文件更新完畢，kanban 文件只是這些工作的記錄載體。
