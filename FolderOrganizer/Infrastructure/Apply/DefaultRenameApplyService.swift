// Services/DefaultRenameApplyService.swift
//
// RenamePlan を実際に Apply する
//

import Foundation

final class DefaultRenameApplyService {

    func apply(_ plan: RenamePlan) throws {

        guard plan.isChanged else { return }

        try FileManager.default.moveItem(
            at: plan.originalURL,
            to: plan.targetURL
        )
    }
}
