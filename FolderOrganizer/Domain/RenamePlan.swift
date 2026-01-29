// Domain/Plan/RenamePlan.swift
//
// 1ファイル分のリネーム計画
// - originalURL: 元の場所
// - targetParentURL: 移動先フォルダ
// - item.finalName: 最終ファイル名
//

import Foundation

struct RenamePlan: Identifiable, Hashable, Codable {

    // MARK: - Identity
    let id: UUID

    // MARK: - Paths
    let originalURL: URL
    let targetParentURL: URL

    // MARK: - Item
    let item: RenameItem

    // MARK: - Computed

    /// 実際に適用される最終 URL
    var finalURL: URL {
        targetParentURL.appendingPathComponent(item.finalName)
    }

    // MARK: - Init
    init(
        id: UUID = UUID(),
        originalURL: URL,
        targetParentURL: URL,
        item: RenameItem
    ) {
        self.id = id
        self.originalURL = originalURL
        self.targetParentURL = targetParentURL
        self.item = item
    }
}

// MARK: - Immutable Update API
extension RenamePlan {

    func updatingFinalName(_ newName: String) -> RenamePlan {
        RenamePlan(
            id: self.id,
            originalURL: self.originalURL,
            targetParentURL: self.targetParentURL,
            item: self.item.updatingFinalName(newName)
        )
    }
}
