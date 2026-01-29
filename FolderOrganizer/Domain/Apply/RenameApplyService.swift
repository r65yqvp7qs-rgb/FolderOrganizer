// FolderOrganizer/Domain/Apply/RenameApplyService.swift
//
// RenamePlan を実行する UseCase / Service
// - 新設計の最小実装
// - Domain にのみ依存する
//

import Foundation

protocol RenameApplyService {

    /// Rename を実行する
    /// - Parameters:
    ///   - plans: 対象の RenamePlan 一覧
    ///   - completion: ApplyResult と RollbackInfo を返す
    func apply(
        plans: [RenamePlan],
        completion: @escaping (_ results: [ApplyResult], _ rollbackInfo: RollbackInfo) -> Void
    )
}
