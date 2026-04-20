# 本資料夾說明:已完成任務 (Done)

> **📌 重要提醒:**
>
> **閱讀本規則前,請務必先參考 [KANBAN_INSTRUCTION.md](../../../KANBAN_INSTRUCTION.md)**
>
> 本階段必須遵循:
>
> - 🚫 **最高優先級：嚴禁擅自移動任務或變更狀態** (參考 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#嚴格禁止規則任務檔案移動與狀態變更))
> - 📋 任務卡片必要欄位規範
> - 📋 任務完成標記規範：統一使用 `[✓]`
> - 📋 停下動作等待確認原則
> - 🔖 遵循共通規範 ([COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md))

---

## 🎯 資料夾用途

此資料夾存放**已完成開發、測試通過**的任務。這些任務已經完整經歷了整個開發流程，可以作為專案進度的歷史記錄。

### 📁 資料夾組織規則

⭐ **重要:** 為避免不同 plan 的任務混在一起，任務必須按照所屬 plan 組織：

1. **任務必須放在日期-plan 編號-feature 名稱資料夾中**
   - 例如: `7-Done/2025-12-01-[plan-Xm1q2]-payment-integration/2025-12-01-[plan-Xm1q2]-2-high-[task-Az4a2]-feature-stripe-integration.md`
2. **從 4-Testing/re-testing 移動任務時，保持相同的日期和 plan 資料夾結構**
   - `4-Testing/2025-12-01-[plan-Xm1q2]-payment-integration/xxx.md` → `7-Done/2025-12-01-[plan-Xm1q2]-payment-integration/xxx.md`
3. **⚠️ 資料夾命名格式:** `[YYYY-MM-DD]-[plan-xxxxx]-[feature-name]`
   - ❌ 錯誤: `7-Done/2025-12-01-[plan-Xm1q2]/`（缺少 feature-name）
   - ✅ 正確: `7-Done/2025-12-01-[plan-Xm1q2]-payment-integration/`

**範例結構:**

```
7-Done/
├── 2025-12-01-[plan-Xm1q2]-payment-integration/
│   ├── 2025-12-01-[plan-Xm1q2]-2-high-[task-Az4a2]-feature-stripe-integration.md
│   ├── 2025-12-01-[plan-Xm1q2]-3-mid-[task-k3B9Z]-test-payment-flow.md
│   └── 2025-12-01-[plan-Xm1q2]-4-low-[task-A1b2C]-docs-payment-api.md
├── 2025-12-05-[plan-Rt7w3]-user-authentication/
│   ├── 2025-12-05-[plan-Rt7w3]-1-urgent-[task-Bc8K7]-feature-jwt-implementation.md
│   └── 2025-12-05-[plan-Rt7w3]-2-high-[task-Pq28L]-test-auth-flow.md
├── 2025-12-31-[no-spec]-bugfix-login/
│   └── 2025-12-31-[no-spec]-1-urgent-[task-Bz8k3]-bug-fix-login-timeout.md
└── .done-task-template.md
```

### 📁 無對應 Spec 的任務

對於使用 `[no-spec]` 命名格式的任務：

- **無論是單一任務文件或多個任務文件，都必須放在共同父層資料夾中**
- **檔案命名格式：** `[YYYY-MM-DD]-[no-spec]-[數字]-[優先級]-[task-xxxxx]-[類別]-描述.md`
- **可以在任何階段直接建立 [no-spec] 任務**，不一定要從 1-Specs/ 開始完整流程
- **移動時保持相同的檔案名稱與父層資料夾結構**

**詳細規範：** 請參考 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#無對應-spec-的-plan-文件)

---

## 📋 AI 工具應該做什麼

當 AI 工具將任務從 `4-Testing/` 移到 `7-Done/` 時：

1. **確認測試已通過**
2. **確認 Testing 品質閘門證據完整**
   - 已有測試程式碼檔案清單
   - 已有完整測試指令與輸出
   - 測試統計為全數通過（all green）
3. **更新任務檔案的最終狀態**（見下方修改規範）
4. **將任務檔案移到 `kanban/7-Done/`**
5. **若同批次有 `0-PLAN_OVERVIEW`，同步更新 overview**
   - 任務移到 `7-Done` 後，立即更新 overview 的統計與任務狀態。
   - 若來源資料夾中只剩 `0-PLAN_OVERVIEW`，overview 也必須移到 `7-Done` 同批次資料夾。
6. **🚪 Stage Entry Gate（強制）**
   - 確認來源階段（`4-Testing/`）中該批次文件已不存在（已被 `mv` 移走，非 `cp`）。
   - 若來源資料夾已無同批次文件，刪除空資料夾。
   - 詳見 [COMMON_CONVENTIONS.md - Stage Entry Gate](../COMMON_CONVENTIONS.md#-stage-entry-gate階段進入閘門強制)
7. **停下動作，等待確認**

---

## 🧪 進入 Done 前的強制檢查

任務移入 `7-Done/` 前，必須同時滿足：

1. 已在 `4-Testing/` 完成測試程式碼建立或補齊。
2. 已執行完整測試範圍，且全部測試通過（all green）。
3. 任務文件中已記錄測試指令、完整輸出與測試統計。

若任一項未滿足，任務不得進入 `7-Done/`。
未通過 Testing 品質閘門時，不可進入 `7-Done/`，也不可推進到 `8-Archived/`。

---

## 📝 移動到 done 時必須修改的欄位

當任務從 `4-Testing/` 移到 `7-Done/` 時，必須在任務檔案中進行以下修改：

### ⚠️ 重要:任務完成標記規範

**任務完成時必須使用 `[✓]` 標記,不要使用 `[x]`**

- ✅ 正確: `- [✓] 已完成的項目`
- ❌ 錯誤: `- [x] 已完成的項目`

### 必須修改的欄位

```markdown
**狀態:** 已完成 (Done) ← 從「測試中 (Testing)」改為此

**完成時間:** [填入實際當前時間，格式: YYYY-MM-DD HH:mm] ← 新增此欄位

**總耗時:** ← 新增此欄位，計算從建立到完成的時間

- 開發階段: X 小時/天 (可選欄位)
- 測試階段: X 小時/天 (可選欄位)
- 總計: X 小時/天 (可選欄位)

**最終測試覆蓋率:** XX% ← 從 4-Testing 階段帶過來

**最終測試成功率:** XX% ← 從 4-Testing 階段帶過來
```

**注意:** 從先前階段繼承的「是否可並行執行」和「任務間的依賴關係」欄位應保持不變，作為歷史記錄。

**補充（強制）：**

- 每份任務文件在本階段至少更新兩次：進入 `7-Done` 當下更新一次；完成驗收摘要後再更新一次（完成結果/最終指標）。
- **✅ Stage Exit Checkpoint（強制）**：離開 `7-Done` 進入歸檔前，必須確認所有 checkbox 已勾選為 `[✓]`、補齊最終結果描述、更新 PLAN_OVERVIEW。詳見 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#-stage-exit-checkpoint階段離開檢查點強制)

---

## 📊 已完成任務應包含的完整資訊

一個完整的已完成任務應該包含從頭到尾的所有記錄：

### 基本資訊

- 任務名稱
- 建立時間
- 完成時間
- 總耗時 (可選欄位)

### 分類資訊

- 類別（feature / bug / refactor / test / docs）
- 優先級
- 複雜度

### AI 工具使用記錄

- 負責的 AI 工具 1（工具名稱與時間區間）
- 負責的 AI 工具 2（如有接手，記錄工具名稱與時間區間）

### 開發記錄

- 相關程式碼檔案
- 開發進度清單（應全部完成）

### 測試記錄

- 測試程式碼檔案
- 測試覆蓋率
- 測試成功率
- 測試統計數據

---

## 🎯 此資料夾的用途

`7-Done/` 資料夾中的任務可以用來：

1. **追蹤專案進度** - 查看已完成的功能
2. **評估 AI 工具效率** - 統計各工具處理的任務數量和品質
3. **歷史參考** - 未來類似任務可以參考已完成的任務
4. **產生報告** - 彙整完成的功能清單
5. **複盤檢討** - 分析開發流程是否有改進空間

---

## 📈 建議的統計方式

可以定期統計 `7-Done/` 資料夾中的任務：

- **按 AI 工具分類**：
  - 高階 AI 工具 完成了幾個任務
  - AI 助手 完成了幾個任務
  - 通用 AI 工具 完成了幾個任務

- **按類別分類**：
  - Feature: X 個
  - Bug: X 個
  - Refactor: X 個
  - Test: X 個

- **平均指標**：
  - 平均開發耗時
  - 平均測試覆蓋率
  - 平均測試成功率

---

## ⚠️ 注意事項

- 已完成的任務**不應該再修改**（除非發現記錄錯誤）
- 若發現 done 任務缺少 testing 證據，必須先退回 `4-Testing/` 或 `5-Re-testing/` 補齊
- 如果已完成的功能需要修改，應該建立新的任務（類別為 bug 或 refactor）
- 定期備份 `7-Done/` 資料夾的內容
- 可以按月份或版本建立子資料夾來整理已完成的任務

---

## ✅ 任務生命週期完成

當任務到達 `7-Done/` 資料夾，代表完整經歷了：

1. **To Do** - 任務規劃
2. **Progressing** - 程式碼開發
3. **Testing** - 測試撰寫與執行
4. **Done** - 任務完成

恭喜完成一個任務！🎉
