// FolderOrganizer/App/FlowState.swift
//
// 画面遷移を管理する状態 enum
//

import Foundation

enum FlowState {

    case welcome

    case preview(
        rootURL: URL,
        plans: [RenamePlan],
        selectionIndex: Int?,
        showSpaceMarkers: Bool
    )

    case applying(
        rootURL: URL,
        plans: [RenamePlan]
    )

    case result(
        rootURL: URL,
        plans: [RenamePlan],
        results: [ApplyResult],
        rollbackInfo: RollbackInfo
    )
}
