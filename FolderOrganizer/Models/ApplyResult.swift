// Models/ApplyResult.swift
//
// ApplyService による rename 実行結果を表すモデル。
// 成功・失敗・Undo 用情報をすべて保持する。
//

import Foundation

/// 単一 RenamePlan の適用結果
struct ApplyResult: Identifiable {

    let id = UUID()

    /// 元のリネーム計画
    let plan: RenamePlan

    /// 成功したか
    let isSuccess: Bool

    /// エラー（失敗時のみ）
    let error: Error?

    /// Undo 用（成功時のみ）
    let undoInfo: UndoInfo?

    /// Undo に必要な情報
    struct UndoInfo {
        let from: URL   // 現在の場所
        let to: URL     // 元の場所
    }
}
