// FolderOrganizer/Domain/Apply/DefaultRenameApplyService.swift
//
// RenameApplyService の最小仮実装
//

import Foundation

final class DefaultRenameApplyService: RenameApplyService {

    func apply(
        plans: [RenamePlan],
        completion: @escaping (_ results: [ApplyResult], _ rollbackInfo: RollbackInfo) -> Void
    ) {
        // 仮実装：全て success 扱い
        let results = plans.map { _ in
            ApplyResult.success()
        }

        let rollbackInfo = RollbackInfo(moves: [])

        completion(results, rollbackInfo)
    }
}
