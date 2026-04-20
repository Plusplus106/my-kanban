# 本資料夾說明: 已歸檔專案 (Archived)

> **📌 重要提醒:**
>
> **閱讀本規則前，請務必先參考 [KANBAN_INSTRUCTION.md](../../../KANBAN_INSTRUCTION.md)**
>
> 本階段必須遵循:
>
> - 🚫 **最高優先級：嚴禁擅自移動任務或變更狀態**（參考 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#嚴格禁止規則任務檔案移動與狀態變更)）
> - 📋 檔案移動規則
> - 📋 停下動作等待確認原則
> - 🔖 遵循共通規範（[COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md)）

---

## 🎯 資料夾用途

此資料夾存放**已完成專案的所有相關文件與任務**。當某個專案在 `7-Done/` 已確認完成後，需將該專案文件收斂到 `8-Archived/`。

---

## ✅ 命名與結構（強制）

### 1) 歸檔根資料夾命名（只能用 spec 或 no-spec）

- **有 Spec 流程：** `YYYY-MM-DD-[spec-xxxxx]-專案名稱/`
- **無 Spec 流程：** `YYYY-MM-DD-[no-spec]-專案名稱/`

**禁止事項：**

- ❌ 不可用 `[plan-xxxxx]` 當歸檔根資料夾識別。
- ❌ 不可建立 `YYYY-MM-DD-[plan-xxxxx]-專案名稱/` 這種舊格式。

### 2) 子資料夾名稱

- 規劃文件固定放：`1-Specs/`
- 已完成任務固定放：`done-plans/`

**禁止事項：**

- ❌ 不可再使用 `done-tasks/` 舊名稱。

### 3) Summary 檔名

- **有 Spec 流程：** `[spec-xxxxx]-summary.md`
- **無 Spec 流程：** `[no-spec]-summary.md`

---

## 📁 標準歸檔結構

### 有 Spec 流程

```text
8-Archived/
└── YYYY-MM-DD-[spec-xxxxx]-專案名稱/
    ├── 1-Specs/
    │   ├── [spec-xxxxx]-IDEA_DESCRIPTION.md
    │   ├── [spec-xxxxx]-CLEANUP_AND_INTEGRATION.md
    │   └── ...
    ├── done-plans/
    │   ├── YYYY-MM-DD-[spec-xxxxx]-2-high-[plan-yyyyy]-feature-xxx.md
    │   └── ...
    └── [spec-xxxxx]-summary.md
```

### 無 Spec 流程（no-spec）

```text
8-Archived/
└── YYYY-MM-DD-[no-spec]-專案名稱/
    ├── 1-Specs/                  # 可為空（no-spec 無規劃文件）
    ├── done-plans/
    │   ├── YYYY-MM-DD-[no-spec]-feature-name/
    │   │   ├── YYYY-MM-DD-[no-spec]-2-high-[plan-yyyyy]-feature-xxx.md
    │   │   └── ...
    │   └── ...
    └── [no-spec]-summary.md
```

---

## 🔄 歸檔流程

### 步驟 1: 判定歸檔識別（spec / no-spec）

1. 從來源檔案或來源資料夾名稱判斷。
2. 若名稱含 `[spec-xxxxx]`，歸檔根資料夾使用該 `[spec-xxxxx]`。
3. 若名稱含 `[no-spec]`，歸檔根資料夾必須使用 `[no-spec]`。
4. **禁止使用 `[plan-yyyyy]` 作為歸檔根資料夾識別。**

### 步驟 1.5: 檢查 Testing 品質閘門證據（強制）

歸檔前，必須確認所有準備歸檔的 done 任務都包含以下內容：

1. 測試程式碼檔案記錄。
2. 實際測試指令。
3. 完整測試輸出與統計（all green）。

若任一 done 任務缺少上述證據，不得歸檔，必須先退回 `4-Testing/` 或 `5-Re-testing/` 補齊。
若 Testing 品質閘門未通過，不可歸檔到 `8-Archived/`。

### 步驟 2: 建立歸檔目錄

```bash
# 有 Spec
mkdir -p kanban/8-Archived/YYYY-MM-DD-[spec-xxxxx]-專案名稱/{1-Specs,done-plans}

# 無 Spec
mkdir -p kanban/8-Archived/YYYY-MM-DD-[no-spec]-專案名稱/{1-Specs,done-plans}
```

### 步驟 3: 移動規劃文件（只適用有 Spec）

```bash
mv kanban/1-Specs/YYYY-MM-DD-[spec-xxxxx]-專案名稱/*.md \
   kanban/8-Archived/YYYY-MM-DD-[spec-xxxxx]-專案名稱/1-Specs/
```

no-spec 流程沒有對應 `1-Specs` 來源時，`1-Specs/` 可保留空資料夾。

### 步驟 4: 移動已完成任務

```bash
# 有 Spec（通常為同名資料夾）
mv kanban/7-Done/YYYY-MM-DD-[spec-xxxxx]-專案名稱/*.md \
   kanban/8-Archived/YYYY-MM-DD-[spec-xxxxx]-專案名稱/done-plans/

# 無 Spec plans（必須保留父層資料夾）
mv kanban/7-Done/YYYY-MM-DD-[no-spec]-feature-name \
   kanban/8-Archived/YYYY-MM-DD-[no-spec]-專案名稱/done-plans/
```

**PLAN_OVERVIEW 同步要求（強制）**

- 若來源批次含 `0-PLAN_OVERVIEW`，必須一併移到 `done-plans/`。
- 歸檔前需先更新 overview，確保其任務統計與狀態為最新。
- 若 `7-Done` 來源資料夾中除 overview 外已無其他同批次文件，不可遺留 overview，必須一併搬移。

### 步驟 5: 校正完成標記

歸檔前後都要確認完成項目使用 `[✓]`，不得使用 `[x]`。

- ✅ 正確：`- [✓] 已完成項目`
- ❌ 錯誤：`- [x] 已完成項目`

### 步驟 6: 建立 summary（強制使用模板）

- 模板：`templates/8-Archived/.archived-summary-template.md`
- 檔名規則：
  - 有 Spec：`[spec-xxxxx]-summary.md`
  - 無 Spec：`[no-spec]-summary.md`

欄位不足時填 placeholder，不可省略章節。

### 步驟 7: 清理所有中間階段資料夾（強制）

歸檔完成後，必須確認以下所有中間階段中已無該批次的殘留文件或空資料夾：

1. 有 Spec 時，刪除原 `1-Specs/YYYY-MM-DD-[spec-xxxxx]-專案名稱/`（確認已搬移完成後）。
2. 刪除對應 `2-Plans/` 來源資料夾（或確認無殘留）。
3. 刪除對應 `3-Progressing/` 來源資料夾（或確認無殘留）。
4. 刪除對應 `4-Testing/` 來源資料夾（或確認無殘留）。
5. 刪除對應 `5-Re-testing/` 來源資料夾（如有）。
6. 刪除對應 `6-On-hold/` 來源資料夾（如有）。
7. 刪除對應 `7-Done/` 來源資料夾（或確認 no-spec 來源檔已移走）。
8. 清空 `4-Testing/temp/*` 測試暫存資料（保留資料夾結構）。

### 步驟 8: 收斂檢查（不可重複）

```bash
find kanban/{1-Specs,2-Plans,3-Progressing,4-Testing,5-Re-testing,6-On-hold,7-Done,8-Archived} -type f \
  | grep -E "spec-xxxxx|plan-yyyyy|no-spec"
```

驗收重點：同一歸檔目標的最終文件應只留在 `8-Archived/...`。

---

## 🔍 常見錯誤

1. 使用 `[plan-yyyyy]` 建立歸檔根資料夾。
2. 使用 `done-tasks/` 舊資料夾名稱。
3. no-spec 案件仍建立成 `...-[plan-yyyyy]-...`。
4. summary 檔名仍使用 `[plan-yyyyy]-summary.md`。

---

## ✅ 歸檔檢查清單

- [ ] 歸檔根資料夾識別正確（`[spec-xxxxx]` 或 `[no-spec]`）
- [ ] 歸檔根資料夾不含 `[plan-yyyyy]`
- [ ] `1-Specs/` 已建立（no-spec 可為空）
- [ ] `done-plans/` 已建立並含所有完成任務
- [ ] 每一份 done 任務都有完整 Testing 品質閘門證據（測試程式碼 + 指令 + all green 輸出）
- [ ] summary 已依模板建立（`[spec-xxxxx]-summary.md` 或 `[no-spec]-summary.md`）
- [ ] 完成標記皆為 `[✓]`
- [ ] 完成標記皆為 `[✓]`
- [ ] 原始來源位置已清理（`1-Specs/`、`2-Plans/`、`3-Progressing/`、`4-Testing/`、`5-Re-testing/`、`6-On-hold/`、`7-Done/`），無重複殘留
- [ ] 收斂檢查通過：同一歸檔目標的文件僅存在於 `8-Archived/`

---

**版本:** 1.2
**最後更新:** 2026-03-09
