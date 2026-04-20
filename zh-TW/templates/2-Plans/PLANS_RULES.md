# 本資料夾說明:待辦計畫 (Plans)

> **📌 重要提醒:**
>
> **閱讀本規則前,請務必先參考 [KANBAN_INSTRUCTION.md](../../../KANBAN_INSTRUCTION.md)**
>
> 本階段必須遵循:
>
> - 🚫 **最高優先級：嚴禁擅自移動計畫卡片或變更狀態** (參考 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#嚴格禁止規則任務檔案移動與狀態變更))
> - 🚨 **關鍵規則：Phase 與 Priority 必須正確匹配** (詳見 [PHASE_PRIORITY_GUIDELINES.md](./PHASE_PRIORITY_GUIDELINES.md))
> - ⭐ 計畫並行執行原則
> - 📋 計畫命名規範
> - 📋 計畫卡片必要欄位規範
> - 🔖 共通規範 ([COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md))

---

## 🎯 資料夾用途

此資料夾存放**尚未開始處理**的實作計畫 (Plans)。當依據 Specs 規格文件拆分出具體執行步驟後，所有計畫卡片都應先放在這裡。

### 📁 資料夾組織規則

⭐ **重要:** 為避免不同 Spec 的計畫混在一起，當從 `1-Specs/` 拆分計畫時：

1. **必須在 `2-Plans/` 中建立 Spec 編號資料夾**
   - 從 1-Specs 資料夾名稱或文件中提取 `[spec-xxxxx]` 編號
   - 例如: `1-Specs/2020-10-10-[spec-Xm1q2]-payment-integration/` → `2-Plans/2020-10-10-[spec-Xm1q2]-payment-integration/`
2. **將該 Spec 的所有計畫都放在對應的子資料夾中**
3. **⚠️ 資料夾命名格式:** `[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]`
   - ❌ 錯誤: `2-Plans/2025-12-01-[spec-Xm1q2]/`（缺少 feature-name）
   - ✅ 正確: `2-Plans/2025-12-01-[spec-Xm1q2]-payment-integration/`

**範例結構:**

```
2-Plans/
├── 2025-12-01-[spec-Xm1q2]-payment-integration/
│ ├── 2025-12-01-[spec-Xm1q2]-2-high-[plan-Az4a2]-feature-stripe-integration.md
│ ├── 2025-12-01-[spec-Xm1q2]-3-mid-[plan-k3B9Z]-test-payment-flow.md
│ └── 2025-12-01-[spec-Xm1q2]-4-low-[plan-A1b2C]-docs-payment-api.md
├── 2025-12-05-[spec-Rt7w3]-user-authentication/
│ ├── 2025-12-05-[spec-Rt7w3]-1-urgent-[plan-Bc8K7]-feature-jwt-implementation.md
│ └── 2025-12-05-[spec-Rt7w3]-2-high-[plan-Pq28L]-test-auth-flow.md
├── 2025-12-31-[no-spec]-bugfix-login/
│ ├── 2025-12-31-[no-spec]-1-urgent-[plan-Bz8k3]-bug-fix-login-timeout.md
│ └── 2025-12-31-[no-spec]-2-high-[plan-Mf7n2]-feature-add-export-button.md
├── 2025-12-30-[no-spec]-cleanup-unused-code/
│ └── 2025-12-30-[no-spec]-3-mid-[plan-Pq4w9]-refactor-cleanup-unused-code.md
└── .plan-template.md
```

### 📁 無對應 Spec 的計畫組織

**使用情境：**

- 臨時想到或緊急需要新增的小任務
- 沒有完整的 Spec 或規格流程
- 已經明確知道要做什麼事情，不需要完整的設計階段
- **可以直接在任何階段建立**（2-Plans/、3-Progressing/、4-Testing/ 等），不一定要從 1-Specs/ 開始

**組織規則：**

1. **無論本次是 1 個或多個 plan 文件，都必須先建立共同父層資料夾**
   - 不可直接放在各階段資料夾根目錄
   - 建議父層資料夾命名格式：`[YYYY-MM-DD]-[no-spec]-[feature-name]/`
2. **檔案命名格式：** `[YYYY-MM-DD]-[no-spec]-[數字]-[優先級]-[plan-xxxxx]-[類別]-簡短描述.md`
   - `[YYYY-MM-DD]`：計畫建立的日期，**必須放在最前面**
   - `[no-spec]`：固定標記，表示此計畫沒有對應的 Spec
   - `[數字]`：優先級數字（1-5），用於檔案排序
   - `[優先級]`：優先級代碼（urgent/high/mid/low/suggest）
   - `[plan-xxxxx]`：計畫自己的 5 碼隨機編號
   - 類別和描述：與一般計畫相同

**範例檔名：**

```
2025-12-31-[no-spec]-1-urgent-[plan-Bz8k3]-bug-fix-login-timeout.md
2025-12-31-[no-spec]-2-high-[plan-Mf7n2]-feature-add-export-button.md
2025-12-30-[no-spec]-3-mid-[plan-Pq4w9]-refactor-cleanup-unused-code.md
```

**重要提醒：**

- ✅ 日期**必須放在最前面**（YYYY-MM-DD 格式）
- ✅ 必須包含優先級數字前綴（1-5），以便檔案按優先級排序
- ✅ 仍然需要產生唯一的 5 碼計畫編號
- ✅ 可以在任何階段直接建立，不需要從 1-Specs/ 開始
- ✅ 無論同一批次有 1 個或多個 plan 文件，都必須先建立共同父層資料夾
- ✅ 若 plan 之後跨階段移動，必須保留既有父層資料夾結構
- ❌ 不可使用 `[spec-xxxxx]` 前綴
- ❌ 日期不可省略或使用錯誤格式
- ❌ 不可省略優先級數字前綴

**詳細規範：** 請參考 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md#無對應-spec-的計畫文件)

---

## 📋 AI 工具應該做什麼

當 AI 工具讀取此資料夾時，需要根據不同情況採取不同的操作：

### 情況 A：從 Spec 拆分計畫（完整流程）

當從 `1-Specs/` 資料夾拆分計畫時，應該：

1. **閱讀參考文件**（通常在專案的文件資料夾中）
2. **建立對應的 Spec 子資料夾**
   - 根據來源 Spec 的資料夾名稱，在 `2-Plans/` 中建立同名子資料夾
3. **建立 PLAN_OVERVIEW 文件**
   - ⭐ **必須先建立 `[YYYY-MM-DD]-[spec-xxxxx]-0-PLAN_OVERVIEW.md` 文件**
   - 此文件用於追蹤整體計畫的進度和狀況
   - 內容應包含：任務統計、優先級分布、任務清單、進度追蹤、里程碑等
   - 此文件是該批次 plan 的「目錄索引文件」，後續每次跨階段移動都必須同步更新與移動
4. **將需求拆分為獨立的計畫**，每個計畫建立一個獨立的 `.md` 檔案
   - ⭐ **任務數量限制 (重要):** 根據任務內容複雜程度，將任務拆分為 **1-8 項**。
   - **硬性上限:** 至多 **不超過 8 項任務**。
   - **原則:** 如果不是絕對複雜的任務，應盡量保持簡單的任務數量。
   - ⭐ **優先考慮計畫的獨立性**，讓多個 AI 工具可以並行處理
   - 評估每個計畫是否可以獨立執行（不依賴其他待辦計畫）
   - 盡可能將依賴關係最小化（使用介面優先、Mock 資料等策略）
5. **為每個計畫評估複雜度和依賴關係**
6. **提供並行執行建議**
   - 明確標示哪些計畫可以並行執行
   - 按階段分組（例如：第一階段完成後，第二階段的 3 個計畫可並行）
7. **🚨 關鍵規則：Phase 與 Priority 必須正確匹配**
   - ⚠️ **禁止將緊急/高優先級計畫分配到後期 Phase**
   - ⚠️ **Phase 編號應該反映計畫的優先級和依賴順序**
   - 📖 **詳細指引：** 請參考 [PHASE_PRIORITY_GUIDELINES.md](./PHASE_PRIORITY_GUIDELINES.md) 獲取完整的匹配原則、範例和驗證清單
   - **Phase 分配原則：**
     - **Phase 1（第一階段）：** 緊急 (1-urgent) 和核心高優先級 (2-high) 計畫
     - **Phase 2（第二階段）：** 中高優先級 (2-high) 和核心中優先級 (3-mid) 計畫
     - **Phase 3（第三階段）：** 中優先級 (3-mid) 和低優先級 (4-low) 計畫
     - **Phase 4+（後期階段）：** 低優先級 (4-low) 和建議執行 (5-suggest) 計畫
   - **特殊情況：** 如果「整合測試」或「正式部署」等計畫因依賴關係必須放在最後階段，但優先級為緊急，應該：
     - 在 PLAN_OVERVIEW 中明確標註「⚠️ 最終階段關鍵計畫」
     - 在計畫描述中說明為何優先級高但必須最後執行
     - 確保所有前置計畫都盡快完成，以支援這些關鍵計畫
   - **驗證檢查：** 完成拆解後，檢查每個 Phase 的優先級分布是否合理
     - ❌ 錯誤範例：Phase 4 中出現大量緊急計畫
     - ✅ 正確範例：Phase 1 包含所有緊急計畫，Phase 2-3 逐步降低優先級
8. **將所有建立好的計畫放到對應的 `2-Plans/[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]/` 資料夾**
9. **停下動作，等待確認**

### PLAN_OVERVIEW 生命週期同步規則（強制）

當此批次進入後續階段（`3-Progressing`、`4-Testing`、`7-Done`、`8-Archived`）時，必須遵守：

1. 只要任一 plan 文件跨階段移動，`0-PLAN_OVERVIEW` 必須同步更新內容（狀態、統計、最後更新）。
2. 若來源資料夾僅剩 `0-PLAN_OVERVIEW`，則 overview 也必須移到同一目標資料夾。
3. 移動 overview 後，必須立即更新 overview 中的路徑與任務狀態。
4. overview 的內容必須足以讓使用者只看 overview 就知道每份 plan 文件目前狀態。

### 情況 B：建立獨立計畫（無 Spec）

當使用者要建立臨時或獨立的計畫時（沒有對應的 spec），應該：

1. **確認計畫沒有對應的 spec**
   - 詢問使用者是否這是一個臨時計畫
   - 確認是否需要建立完整的 spec 或只是單一計畫
2. **使用 `[no-spec]` 命名格式**
   - 格式：`[YYYY-MM-DD]-[no-spec]-[數字]-[優先級]-[plan-xxxxx]-[類別]-簡短描述.md`
   - 使用當天日期（YYYY-MM-DD 格式）
   - 產生唯一的 5 碼計畫編號
3. **建立計畫卡片**
   - 必須包含所有必要欄位（見下方「建立計畫卡片的規範」）
   - 不需要建立 PLAN_OVERVIEW 文件
4. **先建立父層資料夾，再放入計畫文件**
   - 無論是單一 plan 文件或 2 個以上的 plan 文件，都必須先建立共同父層資料夾，再將所有計畫文件放進去
   - 後續跨階段時，必須保留相同父層資料夾結構
5. **停下動作，等待確認**

**重要：** 參考 `KANBAN_INSTRUCTION.md` 中的「計畫並行執行原則」，這是系統的最高優先級原則。

---

## 📝 建立計畫卡片的規範

### ⚠️ 重要: 計畫完成標記規範

**計畫完成時必須使用 `[✓]` 標記,不要使用 `[x]`**

- ✅ 正確: `- [✓] 已完成的項目`
- ❌ 錯誤: `- [x] 已完成的項目`
- ✅ 未完成: `- [ ] 待完成的項目`
- ✅ 保持不變: 文字中的 ✅ 符號(如「✅ 正確做法」)保持使用 ✅

### 🔖 計畫檔案命名與編號規範

**重要：所有計畫檔案都必須加上唯一的 5 碼編號前綴，並使用數字前綴使檔案按優先級排列**

詳細規範請參考：[COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md)

**完整命名格式:** `[YYYY-MM-DD]-[spec-xxxxx]-[數字]-[優先級]-[plan-yyyyy]-[類別]-簡短描述.md`

**⭐ 分階段（Phase）計畫命名規則：**

若 PLAN_OVERVIEW 或 Specs 中將計畫明確劃分為不同階段（Phase），**必須**在檔名中加入階段標記，以便按執行順序排序。

**Phase 格式:** `[YYYY-MM-DD]-[spec-xxxxx]-phase-[N]-[數字]-[優先級]-[plan-yyyyy]-[類別]-簡短描述.md`

- **規則：**
  - `phase-[N]`: N 為階段數字 (1, 2, 3...)
  - 若有區分 Phase，則**所有**相關計畫都應加上 `phase-[N]`
  - `phase-[N]` 置於 `[spec-xxxxx]` 之後、`[數字]` 之前
  - **範例：**
    - Phase 1: `2025-12-01-[spec-Ax4m2]-phase-1-1-urgent-[plan-Az4a2]-schema-setup.md`
    - Phase 2: `2025-12-01-[spec-Ax4m2]-phase-2-2-high-[plan-By3n1]-api-endpoints.md`
- **注意事項：**
  - **排序：** 加入 `phase-[N]` 後，檔案總管會自動依 phase 順序排列，優於優先級排序。
  - **彈性：** 若 AI 工具判斷該 Plan 不需分 Phase，則維持原本命名規則即可。

**編號規則：**

- 5 碼，由英文大小寫（A-Z, a-z）和數字（0-9）隨機組成
- 範例編號：`Az4a2`, `k3B9Z`, `A1b2C`, `9zZ8M`

**優先級數字與代碼對照表：**

| 數字 | 代碼    | 說明                   |
| ---- | ------- | ---------------------- |
| 0    | -       | PLAN_OVERVIEW 概況文件 |
| 1    | urgent  | 緊急                   |
| 2    | high    | 高                     |
| 3    | mid     | 中                     |
| 4    | low     | 低                     |
| 5    | suggest | 建議執行               |

**類別代碼:**

- `feature` - 新功能
- `bug` - 錯誤修正
- `refactor` - 重構
- `test` - 測試
- `docs` - 文件

**完整命名範例:**

```
2025-12-01-[spec-Ax4m2]-0-PLAN_OVERVIEW.md ← 概況文件（置頂）
2025-12-01-[spec-Ax4m2]-1-urgent-[plan-Az4a2]-refactor-update-data-model.md ← 緊急計畫
2025-12-01-[spec-Ax4m2]-1-urgent-[plan-k3B9Z]-bug-login-error-fix.md ← 緊急計畫
2025-12-01-[spec-Ax4m2]-2-high-[plan-A1b2C]-feature-user-authentication.md ← 高優先級
2025-12-01-[spec-Ax4m2]-3-mid-[plan-9zZ8M]-feature-dashboard.md ← 中優先級
2025-12-01-[spec-Ax4m2]-4-low-[plan-Mf36K]-docs-update-api-documentation.md ← 低優先級
```

**排列效果：**
使用數字前綴後，檔案會自動按優先級排列：

- 0-PLAN_OVERVIEW（概況文件置頂）
- 1-urgent（緊急計畫排在一起）
- 2-high（高優先級計畫排在一起）
- 3-mid（中優先級計畫排在一起）
- 4-low（低優先級計畫排在一起）

**注意事項:**

- 簡短描述使用小寫英文，單字間用 `-` 連接
- 避免使用中文或特殊字元
- 檔名長度建議不超過 60 字元
- **PLAN_OVERVIEW 文件使用數字 `0`，確保排在最上方**

**模板檔案:**
可參考 `kanban/2-Plans/.plan-template.md` 來快速建立計畫卡片。

---

### 必要欄位

```markdown
**計畫名稱:** [簡短描述計畫]

**建立時間:** [填入實際當前時間，格式: YYYY-MM-DD HH:mm]

**狀態:** 待辦 (To Do)

**類別:** [feature / bug / refactor / test / docs]

**優先級:** [1-urgent / 2-high / 3-mid / 4-low / 5-suggest]

**預估複雜度:** [高 / 中 / 低]

**是否可並行執行:** [是 / 否]

- 說明: [如果否，說明阻塞原因；如果是，說明可與哪些計畫並行]

**參考文件:**

- [列出所有相關的文件路徑]

**計畫描述:**
[詳細說明這個計畫要做什麼]

**是否有子計畫:** [是 / 否]

**子計畫列表:**（如果有）

1. [子計畫 1]
2. [子計畫 2]
   ...

**與其他計畫的依賴關係:**（如果有）

**依賴說明:**

- 依賴: [必須等待哪些計畫完成，格式：[spec-xxxxx]-[yyyyy] 計畫名稱，或同一 spec 內簡寫為 [yyyyy] 計畫名稱]
- 開發階段: [可與哪些計畫並行開發，格式：[spec-xxxxx]-[yyyyy] 計畫名稱，或同一 spec 內簡寫為 [yyyyy] 計畫名稱]
- 執行階段: [執行時需要哪些服務/資源]
- 外部依賴: [需要的第三方服務/套件]
- 可並行開發: [可與此計畫同時開發的計畫列表，格式：[spec-xxxxx]-[yyyyy] 計畫名稱，或同一 spec 內簡寫為 [yyyyy] 計畫名稱]

**📌 引用其他計畫時的格式：**

- 當提到依賴、並行、阻塞、相關的計畫時，必須加上編號
- **跨 Spec 引用格式：** `[spec-xxxxx]-[yyyyy] 計畫描述`
- **同一 Spec 內簡寫格式：** `[yyyyy] 計畫描述`
- 範例：
  - 依賴 [spec-Ax4m2]-[Bc8K7] database-schema 完成資料庫設計（跨 spec 引用）
  - 可與 [Pq28L] frontend-components 並行開發（同一 spec 內）
  - 被 [spec-Bj7Kn]-[Kl9Y3] oauth-integration 阻塞（跨 spec 引用）
```

---

## 🤖 AI 工具分配建議

- **高階推理 (e.g. Claude)**：複雜的架構設計、核心業務邏輯、關鍵演算法
- **快速生成 (e.g. GPT/Claude)**：CRUD 操作、工具函數、重複性代碼、配置檔案

---

## ✅ 完成後的動作

全部計畫建立完成後：

1. 確認每個計畫檔案都包含所有必要欄位
2. 停下動作，等待確認
3. 不要自動移動計畫到其他資料夾
