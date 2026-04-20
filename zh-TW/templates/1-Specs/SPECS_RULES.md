# Specs 資料夾規範

> 本文件是給 AI 的指引，說明如何收集 idea、建立規格文件 (Specs)、拆解實作計畫 (Plans)

> **📌 共通規範：**
>
> 所有建立的規格文件都必須遵循 [COMMON_CONVENTIONS.md](../COMMON_CONVENTIONS.md) 定義的命名、編號和標記規則。
>
> **重要：Specs 文件必須使用 `[spec-xxxxx]` 格式的編號前綴，且同一個 Spec 資料夾內的所有文件使用相同編號。**

---

## 🎯 本文件的用途

當使用者執行 `gen-idea-to-spec-prompt.sh` 時，此文件會被讀取並產生 prompt。

**職責：**

1. 指導 AI 如何透過問答收集使用者的 idea
2. 說明如何根據答案在 `[project]/1-Specs/[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]/` 建立文件
3. 定義文件命名規則與必須建立的文件

---

## 📋 階段 1: 問答引導收集 Idea

### 核心問題（最多 8 個，視情況調整）

**Q1: 核心問題**

> 你想解決什麼問題？或達成什麼目標？

**引導技巧：** 太籠統 → 追問具體場景；太技術 → 追問業務價值

---

**Q2: 解決方案**

> 有什麼初步想法？考慮用什麼技術？

**引導技巧：** 了解現有技術棧、團隊熟悉度

---

**Q3: 範圍界定**

> 哪些是必須做的（Must Have）？哪些不做（Won't Have）？

**引導技巧：** 每個 Must Have 追問驗收標準

---

**Q4: 限制與風險**

> 有什麼已知限制？可能遇到什麼困難？

**引導技巧：** 詢問時間/資源/技術/依賴限制

---

**Q5: 成功指標**

> 如何衡量成功？有什麼具體數字目標？

**範例：** API < 500ms、覆蓋率 > 80%、錯誤率 < 1%

---

**Q6-Q8: 補充問題（選擇性）**

視需要追問：

- **影響範圍：** 影響誰？多嚴重？
- **時機：** 為什麼現在做？
- **預期效益：** 完成後有什麼價值？

**重要：** 如果前面問題已獲得足夠資訊，不需要問完所有問題。

---

## 📄 階段 2: 建立規格文件 (Specs)

### 🔖 檔案命名與編號規範

**重要：Specs 資料夾中的文件必須加上 spec 編號前綴**

**編號規則：**

- 格式：`[spec-xxxxx]-檔案名稱.md`
- 編號：5 碼，由英文大小寫（A-Z, a-z）和數字（0-9）隨機組成
- **同一個 Spec 資料夾內的所有文件必須使用相同的編號**

**檔案命名規則：**

1. 產生一個唯一的 5 碼編號（只在建立第一個文件時產生）
2. 為所有文件加上 `[spec-編號]` 前綴
3. 檔案名稱使用大寫加底線格式

**範例：**

```
1-Specs/2025-12-04-[spec-Ax4m2]-migrate-to-react-native-elements/
  ├── [spec-Ax4m2]-IDEA_DESCRIPTION.md
  ├── [spec-Ax4m2]-CLEANUP_AND_INTEGRATION.md
  ├── [spec-Ax4m2]-API_DESIGN.md
  └── [spec-Ax4m2]-COMPONENT_STRUCTURE.md
```

**正確示例：**

- ✅ 同一資料夾內使用相同編號：`[spec-Ax4m2]-IDEA_DESCRIPTION.md`
- ✅ 同一資料夾內使用相同編號：`[spec-Ax4m2]-API_DESIGN.md`

**錯誤示例：**

- ❌ 缺少 spec 前綴：`[Az4a2]-IDEA_DESCRIPTION.md`
- ❌ 同一資料夾內使用不同編號：`[spec-Ax4m2]-IDEA_DESCRIPTION.md` 和 `[spec-k3B9Z]-API_DESIGN.md`
- ❌ 沒有編號：`IDEA_DESCRIPTION.md`

**引用規則：**
當文件中提到其他規格文件時，使用編號前綴引用：

```markdown
- 參考 [spec-Ax4m2] IDEA_DESCRIPTION 了解核心需求
- 依賴 [spec-Ax4m2] API_DESIGN 的端點定義
```

### ⚠️ 重要: 計畫完成標記規範

**在所有規格文件和實作計畫卡片中，項目完成時必須使用 `[✓]` 標記，不要使用 `[x]`**

- ✅ 正確: `- [✓] 已完成的項目`
- ❌ 錯誤: `- [x] 已完成的項目`
- ✅ 未完成: `- [ ] 待完成的項目`
- ✅ 保持不變: 文字中的 ✅ 符號(如「✅ 正確做法」)保持使用 ✅

### ⚠️ 重要：資料夾結構說明

**正確的資料夾結構：**

```
[project]/1-Specs/[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]/
  ├── [spec-xxxxx]-IDEA_DESCRIPTION.md
  ├── [spec-xxxxx]-CLEANUP_AND_INTEGRATION.md
  └── [spec-xxxxx]-[其他補充文件].md
```

**範例：**

```
your-project/1-Specs/2025-12-01-[spec-Ax4m2]-feature-name/
  ├── [spec-Ax4m2]-IDEA_DESCRIPTION.md
  ├── [spec-Ax4m2]-CLEANUP_AND_INTEGRATION.md
  └── [spec-Ax4m2]-API_DESIGN.md
```

**❌ 錯誤做法：**

- 不要建立名為 `spec/` 的資料夾
- 不要在專案根目錄建立資料夾
- 不要忘記加上 spec 編號前綴
- 不要忘記加上日期

**✅ 正確做法：**

1. 確認專案已有 `1-Specs/` 資料夾
2. 產生唯一的 5 碼 spec 編號
3. 在 `1-Specs/` 資料夾內建立 `[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]/` 子資料夾（日期在最前面）
4. 在該子資料夾內建立所有規格文件，每個文件都加上 `[spec-xxxxx]` 前綴

### 必須建立的文件

#### 1. IDEA_DESCRIPTION.md

**用途：** 記錄使用者需求與完整對話記錄

**格式：**

```markdown
# [專案名稱] - Idea Description

**建立日期：** YYYY-MM-DD
**專案類型：** [新功能/重構/Bug 修復/效能優化]

## 🎯 問題陳述

[核心問題與解決方案]

## 📋 範圍界定

### Must Have

- [功能] - 驗收標準：[...]

### Won't Have

- [不做的項目]

## ⚠️ 限制與風險

[已知限制與潛在風險]

## ✅ 成功指標

- 定量：[具體數字]
- 定性：[質性標準]

## 💬 對話記錄

[完整 Q&A]
```

---

#### 2. CLEANUP_AND_INTEGRATION.md

**用途：** 記錄清理舊程式碼與整合新舊程式碼的規劃

**內容應包含：**

- 需要刪除的舊檔案或過時程式碼
- 需要整合的重複邏輯
- 可以抽出的共用部分
- 新舊程式碼之間的整合點

**如果沒有需要清理或整合：** 在內容中明確說明「分析使用者需求後，認為無需清理或整合現有程式碼」

**格式：**

```markdown
# 清理與整合規劃

## 🗑️ 需要清理的項目

- [檔案路徑] - 原因：[已被新功能取代]
- [函數名稱] - 原因：[不再使用]

（若無）無需清理任何項目

## 🔄 需要整合的項目

- [重複邏輯描述] - 位置：[檔案 A, 檔案 B]
- [相似功能] - 建議：[合併成共用函數]

（若無）無需整合現有程式碼

## 🔧 共用程式碼抽取

- [功能描述] - 建議位置：[utils/xxx.ts]，或根據專案資料夾結構自行決定

（若無）無可抽取的共用程式碼

## 📝 整合注意事項

[需要特別注意的整合細節]

（若無）此為獨立新功能，無特別整合注意事項
```

**重要：**

- 此文件**必須建立**，即使沒有清理或整合需求，也要明確說明
- 此文件會被任務拆解 AI 用來決定是否需要建立「清理與整合」任務
- 如果內容說明無需清理或整合，任務拆解 AI 可以省略清理任務

---

### 選擇性文件（視需求建立）

AI 應根據問答結果的複雜度決定是否需要以下文件：

#### 後端專案相關

**3. ARCHITECTURE.md**

- **時機：** 涉及多個服務/模組的整合、系統架構重構、微服務設計
- **內容：** 系統架構圖、元件關係、資料流向、服務間通訊方式

**4. API_DESIGN.md**

- **時機：** 新增或修改 API、整合第三方 API、RESTful/GraphQL 設計
- **內容：** API 端點清單、Request/Response 格式、錯誤處理規範、認證授權

**5. DATABASE_SCHEMA.md**

- **時機：** 新增資料表、修改 Schema、資料遷移、關聯設計
- **內容：** Schema 定義、索引設計、遷移步驟、回滾方案

#### 前端專案相關

**6. COMPONENT_STRUCTURE.md**

- **時機：** 新增複雜元件、元件重構、設計系統建立
- **內容：** 元件層級結構、Props 定義、狀態管理、可重用元件規劃

**7. UI_UX_DESIGN.md**

- **時機：** 新功能有複雜的使用者介面、互動流程設計
- **內容：** 畫面流程圖、互動邏輯、響應式設計規劃、無障礙設計

**8. STATE_MANAGEMENT.md**

- **時機：** 涉及複雜的狀態管理（Redux、MobX、Context API 等）
- **內容：** 狀態結構設計、Actions/Reducers 規劃、資料流向

**9. ROUTING_NAVIGATION.md**

- **時機：** 多頁面應用、複雜導航邏輯、React Navigation 配置
- **內容：** 路由結構、導航流程、深層連結、參數傳遞

#### React Native / Mobile App 相關

**10. NATIVE_MODULES.md**

- **時機：** 需要使用原生功能、第三方 SDK 整合（相機、推播、地圖等）
- **內容：** 原生模組清單、權限配置、iOS/Android 差異處理

**11. OFFLINE_STORAGE.md**

- **時機：** 離線功能、本地資料快取、AsyncStorage/SQLite 使用
- **內容：** 儲存策略、同步機制、資料結構

**12. PERFORMANCE_OPTIMIZATION.md**

- **時機：** 效能問題、渲染優化、記憶體管理
- **內容：** 優化策略、lazy loading、圖片優化、bundle size 控制

#### 通用文件

**13. TESTING_STRATEGY.md**

- **時機：** 需要明確測試計畫、TDD 開發、E2E 測試
- **內容：** 測試範圍、測試工具、測試案例規劃、覆蓋率目標

**14. DEPLOYMENT_PLAN.md**

- **時機：** 部署流程變更、CI/CD 設定、環境配置
- **內容：** 部署步驟、環境變數、版本控制、rollback 策略

**15. MIGRATION_PLAN.md**

- **時機：** 技術棧升級（如 React 17→18）、套件遷移、重構計畫
- **內容：** 遷移步驟、相容性處理、漸進式遷移策略、風險評估

**16. THIRD_PARTY_INTEGRATION.md**

- **時機：** 整合外部服務（金流、社群登入、分析工具、雲端服務）
- **內容：** 整合步驟、SDK 配置、錯誤處理、測試環境設定

**17. SECURITY_CONSIDERATIONS.md**

- **時機：** 涉及敏感資料、加密、權限管理、資安需求
- **內容：** 安全措施、加密方式、資料保護、漏洞防範

**18. 其他補充文件**

視需求建立：

- 資料同步策略
- 國際化（i18n）規劃
- 主題系統設計
- 錯誤監控方案
- 使用者分析埋點
- A/B 測試計畫
- 等等...

---

## ⚡ 並行性考量（重要）

### 🎯 為什麼要考慮並行性？

後續的任務拆解 AI 會根據這些規格文件建立 `2-Plans/` 任務。如果在 idea-to-specs 階段就考慮並行性，可以：

1. **減少後續工作** - 任務拆解 AI 可以直接參考並行建議
2. **提高開發效率** - 多個 AI 工具可以同時處理不同任務
3. **識別阻塞任務** - 提前標註高優先級、高阻塞性的任務

### 📋 在文件中加入並行性考量

**非強制要求**，但建議在補充文件中加入以下資訊：

#### 在 ARCHITECTURE.md / COMPONENT_STRUCTURE.md 中

```markdown
## 🔀 模組/元件獨立性分析

### 可並行開發的模組

- **模組 A**：獨立功能，無依賴其他模組
- **模組 B**：獨立功能，無依賴其他模組
- **模組 C**：依賴模組 A 的介面定義，介面定義完成後可並行

### 高阻塞性模組（建議優先處理）

- **核心模組 X**：其他模組都依賴此模組，需最優先完成
- **共用元件 Y**：多個畫面會使用，建議優先建立
```

#### 在 API_DESIGN.md 中

```markdown
## 🔀 API 端點獨立性

### 可並行開發的端點

- `/api/users` - 獨立端點，無依賴
- `/api/products` - 獨立端點，無依賴
- `/api/orders` - 依賴 users 和 products 的資料結構定義

### 高阻塞性端點（建議優先處理）

- `/api/auth` - 認證端點，其他端點都需要，最優先
- 資料結構定義 - 多個端點共用，需優先確定
```

#### 在 DATABASE_SCHEMA.md 中

```markdown
## 🔀 資料表獨立性

### 可並行建立的資料表

- `users` 表 - 獨立表
- `products` 表 - 獨立表
- `orders` 表 - 依賴 users 和 products，需等待外鍵定義

### 高阻塞性資料表（建議優先處理）

- 核心資料表需優先建立
- 共用的查詢表（lookup tables）需優先定義
```

### 💡 並行性思考原則

1. **識別獨立模組** - 哪些功能/元件/API 可以獨立開發？
2. **識別依賴關係** - 哪些需要等待其他部分完成？
3. **標註阻塞任務** - 哪些任務會阻塞其他任務，需優先處理？
4. **建議執行順序** - 如果有明確的順序建議，可以註明

### ⚠️ 注意事項

- **不是強制要求** - AI 根據實際需求決定是否加入並行性分析
- **不要過度設計** - 簡單功能不需要複雜的並行性分析
- **保持彈性** - 任務拆解 AI 仍可根據實際情況調整

---

## 🔧 階段 3: 通知任務拆解

### AI 完成後應該:

1. **告知使用者文件已建立**
   - 列出建立的文件清單
   - 說明每個文件的用途

2. **說明下一步流程**
   - 下一步由任務拆解 AI 接手
   - 任務拆解 AI 會讀取這些文件並產生任務到 `2-Plans/[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]/`
   - **Phase 結構提示：** 若您的規劃中有明確的 Phase 劃分，請提醒任務拆解 AI 參考 `PLANS_RULES.md` 中的 Phase 命名規則（加入 `phase-[N]` 標記）。
   - ⭐ **重要:** 任務拆解 AI 必須在 `2-Plans/` 資料夾中建立與此 Spec 同日期和編號的子資料夾
     - 例如: `1-Specs/2025-12-01-[spec-Ax4m2]-feature-name/` → `2-Plans/2025-12-01-[spec-Ax4m2]-feature-name/`
     - 這樣可避免不同 Spec 的任務混在一起
   - 無論後續是 1 個或多個 plan 文件，都必須先確認父層資料夾已建立後再寫入

3. **提醒清理任務與任務數量限制**
   - 因為已建立 `CLEANUP_AND_INTEGRATION.md`
   - 任務拆解 AI 需要在測試任務之後建立清理任務
   - **任務數量限制 (重要):** 提醒任務拆解 AI 應根據任務內容複雜程度，將任務拆分為 1-8 項，**至多不超過 8 項任務**。若非絕對複雜的任務，應盡量保持簡單的任務數量。

---

## 📝 AI 的職責清單

### ✅ 應該做

1. **循序漸進問答** - 一次一個問題，等待回答
2. **主動追問細節** - 確保資訊完整、驗收標準明確
3. **記錄完整對話** - 保存在 IDEA_DESCRIPTION.md
4. **彙整規格文件** - 根據複雜度決定建立哪些文件
5. **必須建立 CLEANUP_AND_INTEGRATION.md** - 即使簡單功能也要思考清理需求
6. **優先考量並行性** - 在文件中思考並行處理的可能性（詳見下方說明）
7. **規劃任務規模** - 確保整體需求可被拆分為 1-8 個獨立任務，並以簡短任務數量為首選

### ❌ 不應該做

1. **不要拆分任務** - 這是任務拆解 AI 的職責
2. **不要假設答案** - 不清楚就追問，不要替使用者做決定
3. **不要決定實作細節** - 只收集需求，實作由執行 AI 決定
4. **不要強制問完所有問題** - 資訊足夠可提前結束

---

## 📚 相關文件

- `KANBAN_INSTRUCTION.md` - 完整的 Kanban 流程與並行執行原則
- `templates/2-Plans/PLANS_RULES.md` - 實作計畫卡片格式（任務拆解 AI 參考）
- `templates/1-Specs/.specs-idea-to-docs-template.md` - 規格文件產生模板（可選）

---

## 💡 範例

### 簡單功能（至少 3 個文件）

```
1-Specs/2025-12-01-[spec-Bk3n7]-fix-api-error/
  ├── [spec-Bk3n7]-IDEA_DESCRIPTION.md
  ├── [spec-Bk3n7]-CLEANUP_AND_INTEGRATION.md
  └── [spec-Bk3n7]-API_DESIGN.md  (說明要修改的 API 規格)
```

### 中型功能

```
1-Specs/2025-12-01-[spec-Cm5p2]-feature-integration/
  ├── [spec-Cm5p2]-IDEA_DESCRIPTION.md
  ├── [spec-Cm5p2]-CLEANUP_AND_INTEGRATION.md
  ├── [spec-Cm5p2]-API_DESIGN.md
  ├── [spec-Cm5p2]-THIRD_PARTY_INTEGRATION.md
  └── [spec-Cm5p2]-SECURITY_CONSIDERATIONS.md
```

### 複雜功能

```
1-Specs/2025-12-01-[spec-Dq8x4]-system-refactor/
  ├── [spec-Dq8x4]-IDEA_DESCRIPTION.md
  ├── [spec-Dq8x4]-CLEANUP_AND_INTEGRATION.md
  ├── [spec-Dq8x4]-ARCHITECTURE.md
  ├── [spec-Dq8x4]-DATABASE_SCHEMA.md
  ├── [spec-Dq8x4]-API_DESIGN.md
  ├── [spec-Dq8x4]-MIGRATION_PLAN.md
  └── [spec-Dq8x4]-TESTING_STRATEGY.md
```

### React Native App 功能

```
1-Specs/2025-12-01-[spec-Er2k9]-offline-feature/
  ├── [spec-Er2k9]-IDEA_DESCRIPTION.md
  ├── [spec-Er2k9]-CLEANUP_AND_INTEGRATION.md
  ├── [spec-Er2k9]-OFFLINE_STORAGE.md
  ├── [spec-Er2k9]-STATE_MANAGEMENT.md
  └── [spec-Er2k9]-PERFORMANCE_OPTIMIZATION.md
```

---

## ⚠️ 重要提醒

1. **IDEA_DESCRIPTION.md** - 必須建立
2. **CLEANUP_AND_INTEGRATION.md** - 必須建立（思考清理與整合需求）
3. **至少一個補充文件** - 即使是簡單功能，也要根據問答結果建立至少一個相關的補充文件
4. **檔案命名** - 使用 `[spec-xxxxx]` 前綴 + 大寫加底線（如：`[spec-Ax4m2]-API_DESIGN.md`）
5. **存放位置** - `[project]/1-Specs/[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]/`（日期在前）
   - ⚠️ **重要**：必須在 `1-Specs/` 資料夾內建立 `[YYYY-MM-DD]-[spec-xxxxx]-[feature-name]/` 子資料夾
   - ❌ **錯誤範例**：建立名為 `spec/` 的資料夾或忘記加上 spec 編號或日期
   - ✅ **正確範例**：`your-project/1-Specs/2025-12-01-[spec-Ax4m2]-feature-name/`

**為什麼至少要有 3 個文件？**

- 即使是簡單的功能，也需要說明技術細節（API、元件、資料結構等）
- 這些補充文件能幫助任務拆解 AI 更準確地建立計畫
- 避免重要的實作細節只存在於對話記錄中

這些文件會被任務拆解 AI 讀取，用來產生具體的實作計畫到 `2-Plans/` 資料夾。
