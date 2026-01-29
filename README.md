# FolderOrganizer

FolderOrganizer は、フォルダ名のリネームを **安全に・確認しながら** 行うための macOS アプリです。  
単なる一括リネームではなく、

- 事前プレビュー
- 手動編集
- 差分確認
- Apply / Undo

を一連の流れとして提供します。

---

## ✨ 主な特徴

- フォルダ名の **DryRun / Preview**
- スペース可視化（半角 / 全角）
- 手動編集（Rename/Edit）
- 差分表示（Diff）
- **Apply → Undo** の安全な往復操作
- 実行結果の明確な可視化（成功 / 失敗）

---

## 🧠 基本設計思想

### 1. 安全第一（DryRun 前提）

FolderOrganizer は、**必ず Preview を経由**してから Apply を行います。  
ユーザーは「何がどう変わるか」を確認した上で操作できます。

---

### 2. Apply / Undo は対称構造

Apply と Undo は **完全に対称な体験**として設計されています。

- Apply：RenamePlan → ApplyResult
- Undo：ApplyResult → UndoResult

どちらも  
**Domain が結果モデルを生成し、View は表示に専念**します。

---

### 3. Undo は「操作」ではなく「安心」

Undo は再操作のための機能ではなく、

> 「元に戻せた / 戻せなかった」を明確に伝える

ための体験として設計されています。

- Undo は即実行
- 結果は成功 / 失敗で一覧表示
- 次の行動を強制しない（閉じるのみ）

---

## 🧩 アーキテクチャ概要

Domain
└─ Apply
├─ RenamePlan
├─ ApplyResult
└─ UndoResult

Views
├─ Common
│   ├─ ExecutionProgressView
│   └─ ExecutionResultRowView
└─ Rename
├─ Preview
├─ Edit
├─ Apply
└─ Undo

### Domain
- ファイル操作・エラー判定・結果生成を担当
- UI には依存しない

### Views
- 状態遷移と表示に専念
- Apply / Undo は共通 UI を利用

---

## 🔄 基本フロー

1. フォルダ名を読み込み（Preview）
2. 必要に応じて手動編集（Edit）
3. Apply 実行
4. ApplyResult で結果確認
5. 必要であれば Undo 実行
6. UndoResult で結果確認

この一連の流れが **必ず破綻しない** ことを重視しています。

---

## 📝 実装上の方針メモ

- Result モデルは **throw しない**
- エラーは Result に集約する
- View で Domain ロジックを組み立てない
- index ではなく Model の意味単位で状態を管理する

---

## 🚧 今後の予定（メモ）

- 初回 Edit 選択時の状態初期化改善
- UI 細部のチューニング
- Export / Import 機能の拡張
- v0.1 リリースタグ

---

## 🏁 ステータス

現在は **Apply / Undo が一往復できる安定版**です。  
設計の芯が固まり、機能追加や調整を安全に行える状態になっています。

--

# FolderOrganizer (v0.2)

macOS 向けのフォルダ名整理・リネーム支援アプリです。  
大量のフォルダを安全にリネームし、その履歴を **JSON ログとして自動保存** します。

---

## ✨ 特徴（v0.2）

### ✅ 安全なフォルダリネーム
- フォルダ配下をスキャンしてリネーム候補を生成
- Apply 前に一覧で確認
- skipped / failure を含めた結果表示

### ✅ JSON Export（自動保存）
- Apply 実行ごとに **RenameSessionLog を自動保存**
- 保存場所：
~/Library/Application Support/FolderOrganizer/Logs/
- 失敗・スキップを含めた「実行結果の完全スナップショット」

### ✅ Undo 対応のための情報保持
- Undo 用 move 情報をログに含めて保存
- v0.3 以降で Import / Undo 復元に利用可能

---

## 📦 保存されるログ内容（概要）

- セッションID
- 実行日時
- 対象ルートフォルダ
- 各 RenamePlan の詳細
- original / final name
- issue（subtitle / potentialSubtitle など）
- Apply 結果
- success / skipped / failure
- Undo 用 move 情報

すべて **人間が読める JSON** として保存されます。

---

## 🚧 現在できないこと（v0.2）

- JSON ログの Import
- UI からの Export 操作
- Undo の実行（ログは保存されるが UI は未提供）

---

## 🔮 今後の予定

- v0.3：ログ Import / Undo 復元
- Rename 履歴を使ったルール学習
- より高度な分類・判定ロジックの追加

---

## 🛠 技術スタック

- Swift / SwiftUI
- macOS
- Domain / Infrastructure / View 分離設計
- JSON Export（Codable）

---

## 📌 バージョン

- v0.2.0  
- JSON Export（自動保存）対応
- Apply フロー安定版
