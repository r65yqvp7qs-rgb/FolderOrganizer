# FolderOrganizer

macOS 向けのフォルダ名整理・リネーム支援アプリです。  
単純な一括リネームではなく、**「意図が分かる変換プレビュー」**と  
**安全な適用フロー**を重視しています。

---

## 目的

- フォルダ名の揺れ（全角/半角/スペース/記号）を整理したい
- 自動変換だけでなく「人の判断」を途中に挟みたい
- 実行前に変更内容を **視覚的に確認** したい
- 将来的に Undo / 再適用 / 学習につなげたい

---

## アーキテクチャ概要

本プロジェクトは、責務を明確に分離した構成を採用しています。

App            : アプリ全体の入口・背景・トーン
Views          : 画面/UI（SwiftUI）
Domain         : 意味を持つデータ構造
Logic          : 計算・判定ロジック
Infrastructure : ファイル操作など実処理

---

## Views 構成

### Views/Common

複数画面で再利用される **純粋な UI コンポーネント**。

- `SpaceMarkerTextView`  
  半角/全角スペースを可視化する表示 View
- `DiffTextView`  
  Rename 向け差分表示（same / added / replaced）
- `CardStyle`  
  macOS らしい Card UI の共通スタイル

---

### Views/Rename

リネーム作業のメインフロー。

Views/Rename
├─ List
├─ Preview
├─ Detail
├─ Edit
└─ Apply

#### Preview Views の責務

- **PreviewListContentView**  
  Preview 一覧の中身のみを担当する View  
  （LazyVStack + ForEach）

- **PreviewRowView**  
  Preview 一覧用の互換ラッパー View。  
  実体は `RenameRowView` を再利用する。

- **RenamePreviewList**  
  Preview 一覧全体のコンテナ View  
  （ScrollView / 選択管理）

- **RenamePreviewRow**  
  Preview 固有の Card UI・選択状態の表現を担当する View

---

### Views/Rename/Detail

- **RenameDetailView**  
  旧 → 新の変換内容を Diff 表示付きで確認・編集する画面

- **MaybeSubtitleDecisionView**  
  自動判定では確定できない場合に  
  ユーザー判断を求める補助 View

---

## Diff 表示設計（Rename 特化）

Diff は Git 的な完全差分ではなく、  
**「新しい名前を読む」ための最小情報表示**を目的としています。

### Diff の種類

- `same`      : 変化なし
- `added`     : 新しく追加された文字
- `replaced`  : 置き換えられた文字

※ 削除文字は表示しません。

### 構成

- `DiffBuilder`（Logic）  
  old / new から DiffToken を生成する

- `DiffToken`（Domain）  
  差分の意味を持つデータ構造

- `DiffTextView`（Views/Common）  
  色・太字・ライト/ダーク対応を含む表示 View

---

## Domain について

Domain は **意味を持つデータ構造**を置く場所です。

- `RenameItem`
- `RenamePlan`
- `RenameWarning`
- `DiffToken / DiffSegment`

DiffToken / DiffSegment は  
**一時的な計算結果だが意味を持つドメインモデル**として  
Domain に配置しています。

---

## 設計方針（重要）

- ファイル名と struct 名を一致させ、View は必ず `View` を付ける
- ViewBuilder 内で計算を行わない（計算は外で）
- UI / Logic / Domain を混在させない
- 「将来消せる」「将来分けられる」構成を優先する

---

## 現在の状態

- Rename / Preview / Detail / Edit フローが確立
- Diff 表示（added / replaced）が安定
- ファイル構成は拡張前提で整理済み

Views/Rename
 ├─ List        // 一覧（通常リスト）
 ├─ Preview     // 変換プレビュー
 ├─ Detail      // 詳細・判断
 ├─ Edit        // 編集操作
 └─ Apply       // 適用・結果

## Apply / Undo フロー（設計メモ）

Rename の適用は、以下の段階を踏む安全設計とする。

1. Preview  
   変更内容を Diff 表示で確認する段階

2. Apply Confirmation  
   実行前にまとめて確認する段階

3. Apply Execution  
   ファイル操作を実行する段階  
   （Infrastructure に処理を委譲）

4. Result / Undo  
   実行結果を記録し、Undo 可能な状態を残す

Apply / Undo は UI・Logic・Infrastructure を分離し、
将来的な DryRun / 再実行 / ログ保存に対応できる構成とする。

- RenamePreviewRowView: Rename 専用の最終 Preview 表示
- PreviewRowView: Preview 一覧のための互換レイヤー（RenameRowView に委譲）

## 今後の拡張メモ

- Undo / Redo
- 過去の Rename 結果の再適用
- ユーザー判断（Subtitle 等）を学習データとして蓄積
- 正規化ルールの改善ループ

これらは Domain / Logic 層に閉じる形で追加する想定。


# STEP 2️⃣（現時点の設計を固定する版） 

# FolderOrganizer

フォルダ名を安全に整理・正規化する macOS アプリ。
リネーム処理を Dry Run → Preview → Apply → Undo の流れで可視化し、
ユーザー判断を取り込みながら安全に実行することを目的とする。

---

## コンセプト
- 壊さないリネーム
- 直接変更しない
- まず Preview / Diff を見せる
- 人間の判断を組み込む
- subtitle / author などは自動判定＋手動判断
- やり直せる
- Apply 後も Undo 可能
- UI と Domain を分離
- ロジックは Domain、表示は Views

---

## 全体構成

FolderOrganizer
├─ App
│  └─ ContentView.swift
│
├─ Domain
│  ├─ Apply
│  ├─ Normalize
│  ├─ RenamePlan
│  ├─ RoleDetection
│  ├─ Undo
│  └─ DiffSegment / DiffToken
│
├─ Logic
│  ├─ RenamePlanEngine
│  ├─ DiffBuilder
│  └─ NameNormalizer
│
├─ Views
│  ├─ Common
│  ├─ Rename
│  │  ├─ Preview
│  │  ├─ Detail
│  │  ├─ Edit
│  │  ├─ Apply
│  │  └─ List
│  └─ Settings
│
└─ Tests

---

## Rename フロー（UI）

Preview List
   ↓
Rename Preview (Detail)
   ↓
Edit（手動修正）
   ↓
Apply Confirmation
   ↓
Apply / Undo

Preview
- RenamePreviewListView
- RenamePreviewRowView

## 役割：
- 複数リネーム候補を一覧表示
- SpaceMarker / Diff 表示で差分を可視化

Preview（互換レイヤー）
- PreviewListContentView
- PreviewRowView

既存構造との互換用ラッパー
中身は RenamePreviewRowView に委譲している
将来削除候補（README に明示）

---

## Diff 表示
- Domain
- DiffSegment
- DiffToken
- Logic
- DiffBuilder
- View
- DiffTextView

責務分離：

Domain: 差分の意味（追加 / 削除 / 同一）
Logic : 差分の生成
View  : 色・フォントによる表示

---

## スペース可視化
- SpaceMarkerTextView
- 半角スペース：␣
- 全角スペース：□
- Diff / Preview / Detail すべて共通

UI 側で統一し、
文字列ロジックには影響させない。

---

## Edit（手動修正）
- RenameEditView
- MonospaceTextEditor

方針：
    •    モノスペースで差分が見やすい
    •    Common View として再利用可能なため Views/Common に配置

---

Apply / Undo
    •    Domain
    •    ApplyResult
    •    DefaultRenameApplyService
    •    DefaultRenameUndoService
    •    UI
    •    ApplyConfirmationView
    •    ApplyExecutionView

ApplyResult について
- UI ではない
- リネーム操作の結果を表す Domain 型
- Undo / Export / Import で共通利用

→ Domain/Apply に置くのが正解

---

## Subtitle / Author 判定
- 自動判定：RoleDetector
- 手動判断：
- MaybeSubtitleDecisionView
- UserDecisionStore

ユーザー判断は保存され、
次回以降の RenamePlan に反映される。

---

## 設計方針まとめ
- View 名は必ず ◯◯View
- Domain は UI に依存しない
- Preview / Rename / Apply は View フォルダで明確に分離
- 「将来消す可能性のある View」は README に明記する

---

## 現在の状態
- Preview / Diff / SpaceMarker：安定
- Rename/Edit：整理完了
- Apply / Undo：UI 仕上げ段階
- README：設計のスナップショットとして固定

---

## 今後の予定
- Apply / Undo UI の最終調整
- Rename/Edit の細部 UX 改善
- 不要 View の段階的削除
- JSON Export / Import の UI 接続

---

Rename/Edit は「文字列の編集と人間の判断」に専念し、
差分生成・適用・取り消しは扱わない。

---

PreviewListContentView / PreviewRowView は旧構造互換のため残置。将来削除予定。

---

MonospaceTextEditor は Rename/Edit に限らず、
差分・結果・JSON 表示など複数箇所で使われるため Common に配置する。

---


# FolderOrganizer

macOS 向けのフォルダ名整理・リネーム支援アプリ。

直接リネームを実行するのではなく、
Dry Run → Preview → Apply → Undo の流れを通し、
差分を視覚的に確認しながら安全に処理することを目的とする。

---

## 基本方針

- 壊さない（必ず Preview を挟む）
- 人間の判断を尊重する
- やり直せる（Undo 前提）
- UI / Domain / Logic を分離する

---

## ディレクトリ構成

FolderOrganizer
├─ App
├─ Domain
│  ├─ Apply
│  ├─ Undo
│  ├─ RenamePlan
│  ├─ RoleDetection
│  └─ DiffToken / DiffSegment
│
├─ Logic
│  ├─ RenamePlanEngine
│  ├─ DiffBuilder
│  └─ NameNormalizer
│
├─ Views
│  ├─ Common
│  └─ Rename
│     ├─ List
│     ├─ Preview
│     ├─ Detail
│     ├─ Edit
│     └─ Apply
│
└─ Tests

---

## Rename フロー

List
↓
Preview
↓
Detail / Edit
↓
Apply Confirmation
↓
Apply Execution
↓
Result / Undo

---

## Preview Views

### 正式 View
- RenamePreviewListView
- RenamePreviewRowView

### Legacy View（互換用）
- PreviewListContentView
- PreviewRowView

これらは旧構造互換のため残しており、
新規実装では使用しない。将来削除予定。

---

## Edit / Decision

- RenameEditView  
  文字列編集専用 View。Diff 生成や Apply 処理は行わない。

- MaybeSubtitleDecisionView  
  subtitle 判定をユーザーに委ねる補助 View。
  判断結果は UserDecisionStore に保存される。

---

## Diff 表示

- Domain: DiffToken / DiffSegment
- Logic : DiffBuilder
- View  : DiffTextView

Diff は Git 的な完全差分ではなく、
新しい名前を読むための最小差分表示とする。

---

## Common Views

- SpaceMarkerTextView
- DiffTextView
- MonospaceTextEditor

これらは文脈を持たない UI 部品として Common に配置する。

---

## Apply / Undo

- Domain: ApplyResult / UndoResult
- Logic : ApplyService / UndoService
- View  : ApplyConfirmationView / ApplyExecutionView / ResultView

ApplyResult は UI ではなく Domain 型であり、
Undo / Export / Import で共通利用される。

---

## 設計ルール

- View は必ず `◯◯View`
- Domain は UI を知らない
- Legacy View は README に明記する
- 削除は「検索0件 + ビルド通過」を条件とする


⸻

# 最終仕上げ案

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


⸻
