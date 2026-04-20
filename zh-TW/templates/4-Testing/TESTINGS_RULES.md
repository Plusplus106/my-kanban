# 本資料夾說明:測試中任務 (Testing)

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
> - ⭐ 並行測試處理原則
> - ⭐ **Lint 檢查必須通過** (所有測試程式碼必須通過 ESLint/TSLint/Pylance 檢查)
> - 🔖 遵循共通規範 ([COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md))

---

## 🎯 資料夾用途

此資料夾存放**已進入測試執行流程**的任務。當程式碼開發完成後，任務會從 `3-Progressing/` 移到這裡，並且必須完成測試程式碼建立、測試執行與 all green 驗證。

### 📁 資料夾組織規則

⭐ **重要:** 為避免不同 plan 的任務混在一起，任務必須按照所屬 plan 組織：

1. **任務必須放在日期-plan 編號-feature 名稱資料夾中**
   - 例如: `4-Testing/2025-12-01-[plan-Xm1q2]-payment-integration/2025-12-01-[plan-Xm1q2]-2-high-[task-Az4a2]-feature-stripe-integration.md`
2. **從其他階段移動任務時，保持相同的日期和 plan 資料夾結構**
3. **⚠️ 資料夾命名格式:** `[YYYY-MM-DD]-[plan-xxxxx]-[feature-name]`
   - ❌ 錯誤: `4-Testing/2025-12-01-[plan-Xm1q2]/`（缺少 feature-name）
   - ✅ 正確: `4-Testing/2025-12-01-[plan-Xm1q2]-payment-integration/`

**範例結構:**

```
4-Testing/
  ├── 2025-12-01-[plan-Xm1q2]-payment-integration/
  │   ├── 2025-12-01-[plan-Xm1q2]-2-high-[task-Az4a2]-feature-stripe-integration.md
  │   └── 2025-12-01-[plan-Xm1q2]-3-mid-[task-k3B9Z]-test-payment-flow.md
  ├── 2025-12-05-[plan-Rt7w3]-user-authentication/
  │   └── 2025-12-05-[plan-Rt7w3]-1-urgent-[task-Bc8K7]-feature-jwt-implementation.md
  ├── 2025-12-31-[no-spec]-bugfix-login/
  │   └── 2025-12-31-[no-spec]-1-urgent-[task-Bz8k3]-bug-fix-login-timeout.md
  └── .testing-task-template.md
```

### 📁 無對應 Spec 的任務

對於使用 `[no-spec]` 命名格式的任務：

- **無論是單一任務文件或多個任務文件，都必須放在共同父層資料夾中**
- **檔案命名格式：** `[YYYY-MM-DD]-[no-spec]-[數字]-[優先級]-[task-xxxxx]-[類別]-描述.md`
- **可以直接在 4-Testing/ 建立**，不一定要從 3-Progressing/ 移動過來
- **跨階段移動時必須保留父層資料夾結構**

**詳細規範：** 請參考 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#無對應-spec-的-plan-文件)

---

## 📋 AI 工具應該做什麼

當 AI 工具讀取此資料夾中的任務時：

1. **⭐ 選擇任務時考慮優先級和 Phase**
   - 優先選擇緊急 (🔴 1-urgent) 和高優先級 (🟠 2-high) 任務
   - 在同優先級中，優先選擇 Phase 編號較小的任務（Phase 1 > Phase 2 > Phase 3...)
   - 確保符合依賴關係（前置任務已完成）
   - 讀取完 Testing 文件並準備開始實作時，優先檢查任務清單是否有可同步開始實作的任務
   - 若任務彼此可並行且無依賴衝突，開啟同步實作模式
   - 若無法同步開始實作，必須依前後依賴關係逐步執行
   - 詳細說明請參考 [2-Plans/PHASE_PRIORITY_GUIDELINES.md](../2-Plans/PHASE_PRIORITY_GUIDELINES.md)
2. **閱讀任務描述和相關程式碼檔案**
3. **為任務中列出的程式碼檔案撰寫測試程式碼**
4. **執行測試，確保測試通過**
5. **更新任務檔案**（見下方修改規範，必須包含測試指令與完整輸出）
6. **若同批次有 `0-PLAN_OVERVIEW`，同步更新 overview**
   - 任務移入/完成 testing 後，立即更新 overview 狀態統計、最後更新時間。
   - 若來源資料夾中只剩 `0-PLAN_OVERVIEW`，overview 必須移到 `4-Testing` 同批次資料夾。
7. **🚪 Stage Entry Gate（強制）** — 進入 `4-Testing` 時立即執行
   - 確認來源階段（`3-Progressing/`）中該批次文件已不存在（已被 `mv` 移走，非 `cp`）。
   - 若來源資料夾已無同批次文件，刪除空資料夾。
   - 詳見 [COMMON_CONVENTIONS.md - Stage Entry Gate](../COMMON_CONVENTIONS.md#-stage-entry-gate階段進入閘門強制)
8. **以上步驟全部完成後，才開始撰寫測試程式碼並執行測試**
9. **確認 Testing 品質閘門通過**（測試程式碼已建立 + 全部測試通過）
10. **✅ Stage Exit Checkpoint（強制）** — 離開 `4-Testing` 前執行
    - 所有「測試進度」checkbox 已勾選為 `[✓]`
    - 已補齊「測試結果」區塊（測試指令、完整輸出、統計數據）
    - 若有 PLAN_OVERVIEW，已更新統計與狀態
    - 詳見 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#-stage-exit-checkpoint階段離開檢查點強制)
11. **僅在品質閘門 + Exit Checkpoint 都通過後，將任務移到 `kanban/7-Done/`**
12. **停下動作，等待確認**

---

## 🧪 Testing 品質閘門（強制）

只要文件位於 `4-Testing/`，就必須完成以下工作，不得只移動文件：

1. 建立或補齊測試程式碼。
2. 執行專案完整測試範圍（不可只跑單一測試檔）。
3. 確認全部測試通過（all green）。
4. 若專案規範要求 lint/type-check，必須同步通過。
5. 在任務文件「測試結果」區塊記錄：
   - 實際測試指令
   - 完整測試輸出
   - 測試統計（總數/通過/失敗）

未通過以上任一條件，不可移到 `7-Done/` 或 `8-Archived/`。

---

## 📝 開始處理測試時必須修改的欄位

當 AI 工具開始為某個任務撰寫測試時，必須在任務檔案中進行以下修改：

### ⚠️ 重要:任務完成標記規範

**任務完成時必須使用 `[✓]` 標記,不要使用 `[x]`**

- ✅ 正確: `- [✓] 已完成的項目`
- ❌ 錯誤: `- [x] 已完成的項目`

### 必須修改的欄位

```markdown
**狀態:** 測試中 (Testing) ← 從「處理中 (Progressing)」改為此

**測試開始時間:** [填入實際當前時間，格式: YYYY-MM-DD HH:mm] ← 新增此欄位

**測試負責的 AI 工具:** [AI 名稱] ← 新增此欄位

**測試進度:** ← 新增此欄位

- [ ] 任務文件更新完成
- [ ] 測試 module 檢查與安裝
- [ ] 環境配置檢查（如需要外部服務）
- [ ] 測試檔案建立
- [ ] 單元測試撰寫
- [ ] 整合測試撰寫（⚠️ 只有實際執行整合測試時才勾選，否則保持未勾選）
- [ ] 測試執行
- [ ] 使用 4-Testing/temp/ 測試資料驗證（如有測試資料）
- [ ] 測試通過

**環境配置狀態:** ← 新增此欄位（如測試需要連接外部服務）

- 測試環境 URL: [已配置 / 未配置 / 不適用]
- 正式環境 URL: [已配置 / 未配置 / 不適用]
- 資料庫連接: [已配置 / 未配置 / 不適用]
- 其他外部服務: [已配置 / 未配置 / 不適用]
- 備註: [如有環境配置問題，在此說明]

**測試程式碼檔案:** ← 新增此欄位

- [列出所有建立的測試檔案路徑]
```

**注意:** 從 todo 和 3-Progressing 階段繼承的「是否可並行執行」和「任務間的依賴關係」欄位應保持不變。

**補充（強制）：**

- 每份任務文件在本階段至少更新兩次：進入 `4-Testing` 當下更新一次；測試完成後再更新一次（含指令、輸出、統計）。

---

## 🧪 撰寫測試的流程

1. **⭐ 檢查並安裝測試相關 module（重要！必須先執行）**
   - **React / React Native 專案：**
     - 檢查 `package.json` 的 `devDependencies` 是否包含必要的測試套件
     - 必要套件：`jest`, `@testing-library/react-native` (或 `@testing-library/react`), `@testing-library/jest-native`, `@types/jest` (如使用 TypeScript)
     - 如缺少，執行：`npm install --save-dev [缺少的套件]` 或 `yarn add --dev [缺少的套件]`
   - **Python 專案：**
     - 檢查是否已安裝 `pytest`, `pytest-cov` 等測試套件
     - pip 管理：檢查 `requirements-dev.txt` 或 `requirements.txt`，缺少則執行 `pip install pytest pytest-cov`
     - uv 管理：檢查 `pyproject.toml`，缺少則執行 `uv pip install pytest pytest-cov` 或 `uv sync`
   - 在任務卡片的「測試進度」中記錄 module 安裝情況

2. **⭐ 檢查測試環境或正式環境的網址（如需要連接外部服務）**
   - **如果測試需要連接測試機或正式機：**
     - 檢查專案的環境配置檔案（`.env`, `config.json`, 等）
     - 確認測試機網址（Test/Staging Environment URL）是否已配置
     - 確認正式機網址（Production Environment URL）是否已配置
   - **⚠️ 如果找不到測試機或正式機的環境網址：**
     - 在任務文件中說明：「目前找不到測試機或正式機的環境配置，暫時跳過需要外部環境的測試」
     - 在「測試進度」中標記「測試執行」為「部分完成（缺少環境配置）」
     - 記錄缺少的環境資訊和原因
     - 如果是純單元測試（不需要外部環境），則可以正常執行
     - 停下來詢問用戶是否有環境配置資訊，或是否要移到 `6-On-hold/` 等待環境就緒

3. **閱讀功能程式碼**，理解其邏輯和邊界條件

4. **建立測試檔案**（依照專案的測試檔案命名規範）

5. **撰寫測試案例**：
   - 正常情況測試
   - 邊界情況測試
   - 錯誤處理測試
   - 整合測試（⚠️ 依專案需求決定是否撰寫）

   **關於整合測試：**
   - 如果專案只需要單元測試，不撰寫整合測試也完全可以
   - 只有當需要測試多個模組間的互動時，才撰寫整合測試
   - 撰寫了整合測試並執行後，才在測試進度中勾選「整合測試撰寫」
   - 沒有撰寫整合測試時，該項目保持未勾選狀態

6. **執行測試**：`npm test` 或對應的測試指令

7. **⭐ 使用 4-Testing/temp/ 測試資料進行驗證測試（如有測試資料）**
   - 檢查 `4-Testing/temp/` 資料夾是否有測試資料（audio/、data/、images/、scripts/）
   - 如果有測試資料，使用這些實際檔案再次執行驗證測試
   - 確保功能在實際資料下也能正常運作
   - 記錄驗證測試的結果（驗證了幾個檔案）
   - 如果沒有測試資料，標記為「不適用」並跳過此步驟

8. **⭐ 測試執行完成後，立即更新任務文件（重要！）**
   - 完成所有「測試進度」項目的勾選
   - 填寫「測試負責的 AI 工具」的結束時間
   - 在任務文件末尾新增「測試結果」區塊
   - 記錄測試完成時間、測試結果、覆蓋率、統計資訊、執行輸出

9. **確保所有測試通過（all green）**

10. **確認 Testing 品質閘門全部通過**

11. **將任務移到 `7-Done/`**

---

## 📊 測試完成後必須更新任務文件

**⭐ 重要：測試執行完成後，必須立即更新任務文件！**

當測試完成並通過後，在將任務移到 `7-Done/` 之前，必須執行以下更新：

### 1. 更新測試進度（完成所有適用項目）

```markdown
**測試進度:**

- [✓] 任務文件更新完成
- [✓] 測試 module 檢查與安裝
- [✓] 測試檔案建立
- [✓] 單元測試撰寫
- [✓] 整合測試撰寫（⚠️ 只有實際執行整合測試時才勾選）
- [✓] 測試執行
- [✓] 使用 4-Testing/temp/ 測試資料驗證（已驗證 X 個檔案 / 無測試資料，不適用）
- [✓] 測試通過
```

**⚠️ 注意：**

- 如果專案不需要整合測試，「整合測試撰寫」項目保持未勾選 `[ ]`
- 只有實際撰寫並執行了整合測試時，才勾選此項 `[✓]`
- 測試結果必須記錄「實際測試指令」與「完整輸出」，不可只寫摘要

### 2. 填寫測試結束時間

```markdown
**測試負責的 AI 工具:** [AI 名稱] (YYYY-MM-DD HH:mm ~ YYYY-MM-DD HH:mm)
```

範例：

```markdown
**測試負責的 AI 工具:** Claude (2025-01-15 10:30 ~ 2025-01-15 12:45)
**測試負責的 AI 工具:** Claude (2025-01-15 10:30 ~ 2025-01-15 12:45)
```

### 3. 在任務文件末尾新增「測試結果」區塊

```markdown
---

## 測試結果

**測試完成時間:** [填入實際當前時間，格式: YYYY-MM-DD HH:mm]

**測試結果:** 通過 / 失敗

**測試覆蓋率:** XX% ← 如果測試框架有提供

**測試統計:**

- 總測試案例數: X
- 通過: X
- 失敗: X
- 成功率: XX%

**測試執行輸出:**
```

[貼上測試執行的完整終端輸出]

```

```

### 4. 生成測試完成的 Commit 訊息

範例格式：

```
test([project-name]): complete testing for [task-name]

- All tests passed (X/X test cases)
- Test coverage: XX%
- Update task file with test results
- Mark testing progress as completed
```

---

## ⚠️ 注意事項

- **必須確保測試通過**才能移到 `7-Done/`
- **不得只移動文件到 `4-Testing/` 當作 testing 完成**
- 如果測試失敗，需要：
  1. 修正功能程式碼的問題
  2. 或修正測試程式碼的問題
  3. 重新執行測試
- 記錄完整的測試覆蓋率和成功率
- 如果測試框架支援，產生測試覆蓋率報告
- **⚠️ 環境配置問題：**
  - 如果測試需要連接外部服務（測試機/正式機）但找不到環境網址
  - 必須在任務文件中明確說明缺少的環境資訊
  - 可以選擇：
    1. 只執行不需要外部環境的單元測試
    2. 使用 mock 資料模擬外部服務
    3. 將任務移到 `6-On-hold/` 等待環境配置就緒
- **⭐ 遇到錯誤時參考專案文件：**
  - 如果在撰寫或執行測試時遇到錯誤或不確定的問題
  - 應該先閱讀正在處理的專案內的文件，尋找正確的處理方式：
    - `README.md` - 專案說明、安裝步驟、執行方式
    - `docs/` 資料夾 - 專案的詳細文件、API 文件、架構說明
    - `CONTRIBUTING.md` - 貢獻指南、開發規範
    - `package.json` 或 `pyproject.toml` - 測試指令、依賴套件
    - 其他相關設定檔 - `.env.example`, `jest.config.js`, `pytest.ini` 等
  - 從專案文件中可以找到：
    - 正確的測試指令和參數
    - 環境變數的設定方式
    - 測試框架的配置
    - 專案特定的測試慣例或規範
    - 已知問題和解決方案

---

## ✅ 完成後的動作

所有測試完成並通過後：

1. 確認任務檔案已更新所有測試相關欄位
2. 確認測試指令、完整輸出、覆蓋率和成功率已記錄
3. 確認 Testing 品質閘門已全部通過
4. 將任務從 `4-Testing/` 移到 `7-Done/`
5. 停下動作，等待確認
