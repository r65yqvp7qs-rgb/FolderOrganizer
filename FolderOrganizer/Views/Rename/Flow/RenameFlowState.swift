// Domain/RenameFlowState.swift
//
// Rename フロー全体の画面状態を表す enum
//

import Foundation

enum RenameFlowState {

    /// プレビュー（編集・確認フェーズ）
    case preview

    /// Apply 実行中
    case applying

    /// Apply 完了後の結果表示
    case applyResult(results: [ApplyResult])

    /// Undo 実行中
    case undoing

    /// Undo 完了後の結果表示
    case undoResult(results: [UndoResult])
}
