// Logic/RenamePlanBuilder.swift
//
// RenameItem を元に RenamePlan を組み立てる
//

import Foundation

final class RenamePlanBuilder {

    func build(
        item: RenameItem,
        originalURL: URL,
        targetParentURL: URL
    ) -> RenamePlan {

        RenamePlan(
            originalURL: originalURL,
            targetParentURL: targetParentURL,
            item: item
        )
    }
}
