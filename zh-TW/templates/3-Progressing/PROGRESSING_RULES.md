# 本資料夾說明:處理中任務 (Progressing)

> **📌 重要提醒:**
>
> **閱讀本規則前,請務必先參考 [KANBAN_INSTRUCTION.md](../../../KANBAN_INSTRUCTION.md)**
>
> 本階段必須遵循:
>
> - 🚫 **最高優先級：嚴禁擅自移動任務或變更狀態** (參考 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#嚴格禁止規則任務檔案移動與狀態變更))
> - 🚨 **Phase 與 Priority 匹配原則** (詳見 [2-Plans/PHASE_PRIORITY_GUIDELINES.md](../2-Plans/PHASE_PRIORITY_GUIDELINES.md))
> - 📋 程式碼註解必須使用英文
> - 📋 檔案移動規則
> - 📋 任務卡片必要欄位規範
> - 📋 暫存檔案管理
> - ⭐ **Lint 檢查必須通過** (所有程式碼必須通過 ESLint/TSLint/Pylance 檢查)
> - 🔖 遵循共通規範 ([COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md))

---

## 🎯 資料夾用途

此資料夾存放**正在進行程式碼開發**的任務。當 AI 工具開始為某個任務撰寫程式碼時，該任務卡片應移到這裡。

### 📁 資料夾組織規則

⭐ **重要:** 為避免不同 plan 的任務混在一起，任務必須按照所屬 plan 組織：

1. **任務必須放在日期-plan 編號-feature 名稱資料夾中**
   - 例如: `3-Progressing/2025-12-01-[plan-Xm1q2]-payment-integration/2025-12-01-[plan-Xm1q2]-2-high-[task-Az4a2]-feature-stripe-integration.md`
2. **從 todo 移動任務時，保持相同的日期和 plan 資料夾結構**
   - `2-Plans/2025-12-01-[plan-Xm1q2]-payment-integration/xxx.md` → `3-Progressing/2025-12-01-[plan-Xm1q2]-payment-integration/xxx.md`
3. **⚠️ 資料夾命名格式:** `[YYYY-MM-DD]-[plan-xxxxx]-[feature-name]`
   - ❌ 錯誤: `3-Progressing/2025-12-01-[plan-Xm1q2]/`（缺少 feature-name）
   - ✅ 正確: `3-Progressing/2025-12-01-[plan-Xm1q2]-payment-integration/`

**範例結構:**

```
3-Progressing/
├── 2025-12-01-[plan-Xm1q2]-payment-integration/
│   ├── 2025-12-01-[plan-Xm1q2]-2-high-[task-Az4a2]-feature-stripe-integration.md
│   └── 2025-12-01-[plan-Xm1q2]-3-mid-[task-k3B9Z]-test-payment-flow.md
├── 2025-12-05-[plan-Rt7w3]-user-authentication/
│   └── 2025-12-05-[plan-Rt7w3]-1-urgent-[task-Bc8K7]-feature-jwt-implementation.md
├── 2025-12-31-[no-spec]-bugfix-login/
│   └── 2025-12-31-[no-spec]-1-urgent-[task-Bz8k3]-bug-fix-login-timeout.md
└── .progressing-task-template.md
```

### 📁 無對應 Spec 的任務

對於使用 `[no-spec]` 命名格式的任務：

- **無論是單一任務文件或多個任務文件，都必須放在共同父層資料夾中**
- **檔案命名格式：** `[YYYY-MM-DD]-[no-spec]-[數字]-[優先級]-[task-xxxxx]-[類別]-描述.md`
- **可以直接在 3-Progressing/ 建立**，不一定要從 2-Plans/ 移動過來（例如：緊急修復直接開始開發）
- **移動時保持相同的檔案名稱與父層資料夾結構**
  ```
  2-Plans/2025-12-31-[no-spec]-bugfix-login/2025-12-31-[no-spec]-1-urgent-[task-Bz8k3]-bug-fix-login-timeout.md
  ↓
  3-Progressing/2025-12-31-[no-spec]-bugfix-login/2025-12-31-[no-spec]-1-urgent-[task-Bz8k3]-bug-fix-login-timeout.md
  ```

**詳細規範：** 請參考 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#無對應-spec-的-plan-文件)

---

## 📋 AI 工具應該做什麼

當 AI 工具從 `2-Plans/` 挑選任務開始處理時：

1. **⭐ 選擇任務時考慮優先級和 Phase**
   - 優先選擇緊急 (🔴 1-urgent) 和高優先級 (🟠 2-high) 任務
   - 在同優先級中，優先選擇 Phase 編號較小的任務（Phase 1 > Phase 2 > Phase 3...)
   - 確保符合依賴關係（前置任務已完成）
   - 讀取完 Plan 文件並準備開始實作時，優先檢查任務清單是否有可同步開始實作的任務
   - 若任務彼此可並行且無依賴衝突，開啟同步實作模式
   - 若無法同步開始實作，必須依前後依賴關係逐步執行
   - 詳細說明請參考 [2-Plans/PHASE_PRIORITY_GUIDELINES.md](../2-Plans/PHASE_PRIORITY_GUIDELINES.md)
2. **將任務檔案從 `kanban/2-Plans/` 移動到 `kanban/3-Progressing/`**
3. **更新任務檔案的內容**（見下方修改規範）
4. **若同批次有 `0-PLAN_OVERVIEW`，同步更新 overview**
   - 任何任務移到 `3-Progressing` 後，立即更新 overview 的狀態統計與最後更新時間。
   - 若來源資料夾中只剩 `0-PLAN_OVERVIEW`，overview 也要移到 `3-Progressing` 同批次資料夾。
5. **🚪 Stage Entry Gate（強制）**
   - 確認來源階段（`2-Plans/`）中該批次文件已不存在（已被 `mv` 移走，非 `cp`）。
   - 若來源資料夾已無同批次文件，刪除空資料夾。
   - 詳見 [COMMON_CONVENTIONS.md - Stage Entry Gate](../COMMON_CONVENTIONS.md#-stage-entry-gate階段進入閘門強制)
6. **以上步驟全部完成後，才可開始撰寫程式碼**
7. **完成程式碼開發後，停止所有動作**

## 🛑 AI 工具絕對不能做的事

**⚠️ 重要警告：完成程式碼開發後，AI 工具必須立即停止，不得進行以下任何動作：**

❌ **禁止動作：**

1. **不得移動任務檔案到 `4-Testing/` 資料夾**
2. **不得移動任務檔案到 `7-Done/` 資料夾**
3. **不得修改任務檔案的「狀態」欄位為 "Testing" 或 "Done"**
4. **不得修改任務檔案中任何與測試相關的欄位**
5. **不得自行判斷任務已完成**

✅ **正確做法：**

- 完成程式碼開發後，保持任務檔案在 `3-Progressing/` 資料夾
- 保持任務狀態為「處理中 (Progressing)」
- 只更新「開發進度」欄位，標記「✅ 完成開發」
- 停止所有動作，等待人工確認

**理由：** 任務移動和狀態變更由人工負責，確保不會跳過 testing 階段

---

## 📝 移動任務時必須修改的欄位

### ⚠️ 重要:任務完成標記規範

**任務完成時必須使用 `[✓]` 標記,不要使用 `[x]`**

- ✅ 正確: `- [✓] 程式碼框架建立`
- ❌ 錯誤: `- [x] 程式碼框架建立`
- ✅ 未完成: `- [ ] 核心邏輯實現`
- ✅ 保持不變: 文字中的 ✅ 符號(如「✅ 確認任務檔案已更新」)保持使用 ✅

當任務從 `2-Plans/` 移到 `3-Progressing/` 時，必須在任務檔案中進行以下修改：

### 必須修改的欄位

```markdown
**狀態:** 處理中 (Progressing) ← 從「待辦 (To Do)」改為此

**開始處理時間:** [填入實際當前時間，格式: YYYY-MM-DD HH:mm] ← 新增此欄位

**實際使用的 AI 工具:** [高階 AI 工具 / AI 助手 / 通用 AI 工具] ← 新增此欄位，記錄實際處理的 AI

**開發進度:** ← 新增此欄位

- [ ] 程式碼框架建立
- [ ] 核心邏輯實現
- [ ] 錯誤處理
- [ ] 完成開發

**相關程式碼檔案:** ← 新增此欄位，記錄建立或修改的檔案

- [列出所有相關的程式碼檔案路徑]
```

**注意:** 從 todo 階段繼承的「是否可並行執行」和「任務間的依賴關係」欄位應保持不變。

**補充（強制）：**

- 每份任務文件在本階段至少更新兩次：進入 `3-Progressing` 當下更新一次；開發完成後再更新一次。

---

## 🚀 處理任務的流程

1. **閱讀任務描述和參考文件**
2. **規劃程式碼架構**
3. **撰寫程式碼**（包含註解和錯誤處理）
4. **更新「開發進度」欄位**（標記已完成的項目）
5. **停止所有動作，等待人工確認** ⚠️

**⚠️ 特別注意：**

- 第 5 步之後，AI 工具**不得**繼續執行任何動作
- **不得**移動任務檔案
- **不得**修改任務狀態
- 任務的後續流程（移到 4-Testing）由人工負責

---

## ⚠️ 注意事項

- 此階段**不需要撰寫測試程式碼**，只專注於功能開發
- 測試程式碼將在 `4-Testing/` 階段處理
- 如果任務有子任務，記得更新子任務的完成狀態
- 記錄所有建立或修改的檔案路徑

---

## ✅ 完成程式碼開發後的動作

**AI 工具應該做的：**

1. ✅ 確認任務檔案已更新所有必要欄位
2. ✅ 更新「開發進度」欄位，所有 checkbox 標記為 `[✓]`（包含「Lint 檢查通過」、「完成開發」）
3. ✅ 補齊「本次實作結果」描述（修改了哪些檔案、做了什麼）
4. ✅ 若同批次有 `0-PLAN_OVERVIEW`，更新 overview 統計與狀態
5. ✅ **確認 Stage Exit Checkpoint 全部完成**（詳見 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#-stage-exit-checkpoint階段離開檢查點強制)）
6. ✅ **立即停止所有動作**

**🛑 停止後的明確指示：**

- **向使用者回報：** 「程式碼開發已完成，請您確認修改內容並手動處理任務文件」
- **不需要 AI 繼續處理任何事項**
- **等待使用者的下一步指示**

**AI 工具絕對不能做的：**

1. ❌ **不得移動**任務檔案到其他資料夾（testing 或 done）
2. ❌ **不得修改**任務狀態欄位
3. ❌ **不得添加**任何測試相關的內容
4. ❌ **不得自行判斷**任務已完成
5. ❌ **不得主動建議**移動任務或變更狀態

---

## 🔄 後續流程（由人工執行）

程式碼開發完成後，後續流程**完全由使用者手動負責**：

1. ✋ 使用者檢查程式碼品質和修改內容
2. ✋ 使用者手動將任務移到 `4-Testing/` 資料夾
3. ✋ 使用者手動更新任務狀態為「Testing」
4. ✋ 使用者決定何時讓 AI 工具開始撰寫測試程式碼

**重要說明：**

- **AI 工具不參與任務文件的移動和狀態變更**
- **所有任務流程控制由使用者掌握**
- **這個流程確保不會跳過 testing 階段**
- **使用者可以在確認程式碼品質後，再進入下一階段**
