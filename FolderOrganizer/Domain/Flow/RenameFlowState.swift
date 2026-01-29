// FolderOrganizer/Domain/Flow/RenameFlowState.swift
//
//  画面遷移の「仕様」を 1 箇所に集約する State Machine（v0.2）。
//  - ユーザー体験の段階で state を定義
//  - 必要なデータ（rootURL / plans / selection / results / rollbackInfo）を同梱
//  - Equatable は「UI 遷移判定に必要な粒度」のみ比較する
//

import Foundation

/// Rename フローの状態（State Machine）
enum RenameFlowState {

    // MARK: - States

    /// 初期状態（フォルダ未選択）
    case welcome

    /// プレビュー（一覧・編集）
    case preview(
        rootURL: URL,
        plans: [RenamePlan],
        selectionIndex: Int?,
        showSpaceMarkers: Bool
    )

    /// Apply 実行中
    case applying(
        rootURL: URL,
        plans: [RenamePlan]
    )

    /// Apply 結果（Undo 可能）
    case result(
        rootURL: URL,
        plans: [RenamePlan],
        results: [ApplyResult],
        rollbackInfo: RollbackInfo
    )
}

// MARK: - Equatable（手動実装）

extension RenameFlowState: Equatable {

    static func == (lhs: RenameFlowState, rhs: RenameFlowState) -> Bool {

        switch (lhs, rhs) {

        case (.welcome, .welcome):
            return true

        case let (
            .preview(lRoot, lPlans, lSel, lSpace),
            .preview(rRoot, rPlans, rSel, rSpace)
        ):
            return lRoot == rRoot
                && lPlans.count == rPlans.count
                && lSel == rSel
                && lSpace == rSpace

        case let (
            .applying(lRoot, lPlans),
            .applying(rRoot, rPlans)
        ):
            return lRoot == rRoot
                && lPlans.count == rPlans.count

        case let (
            .result(lRoot, lPlans, _, _),
            .result(rRoot, rPlans, _, _)
        ):
            // results / rollbackInfo の中身は比較しない
            //（UI 遷移判定に不要）
            return lRoot == rRoot
                && lPlans.count == rPlans.count

        default:
            return false
        }
    }
}
