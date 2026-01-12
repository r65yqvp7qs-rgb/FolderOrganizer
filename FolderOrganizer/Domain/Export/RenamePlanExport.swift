// Domain/Export/RenamePlanExport.swift
//
// RenamePlan の Export DTO
//

import Foundation

struct RenamePlanExport: Codable {

    // MARK: - Stored (Export)

    let originalPath: String
    let originalName: String
    let normalizedName: String

    let targetParentPath: String
    let targetName: String

    // MARK: - Back to Domain

    func toDomain() -> RenamePlan {

        let originalURL = URL(fileURLWithPath: originalPath)
        let targetParentURL = URL(fileURLWithPath: targetParentPath)

        // Export からは最小限の RenameItem を復元する
        let item = RenameItem(
            original: originalName,
            normalized: normalizedName,
            source: .imported
        )

        return RenamePlan(
            originalURL: originalURL,
            targetParentURL: targetParentURL,
            item: item
        )
    }
}
