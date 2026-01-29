// Domain/Plan/RenameItem.swift
//
// 1行ぶんのリネーム対象
// - original: 元のファイル名
// - editedName: ユーザー編集後の名前（未編集なら nil）
// - finalName: 実際に使われる最終名
//

import Foundation

struct RenameItem: Identifiable, Hashable, Codable {

    // MARK: - Identity
    let id: UUID

    // MARK: - Names
    let original: String
    let editedName: String?

    // MARK: - Meta
    var source: RenameItemSource
    var issues: Set<RenameIssue>

    // MARK: - Computed

    /// 実際に使われる名前
    var finalName: String {
        editedName ?? original
    }

    // MARK: - Init
    init(
        id: UUID = UUID(),
        original: String,
        editedName: String? = nil,
        source: RenameItemSource = .auto,
        issues: Set<RenameIssue> = []
    ) {
        self.id = id
        self.original = original
        self.editedName = editedName
        self.source = source
        self.issues = issues
    }
}

// MARK: - Immutable Update API
extension RenameItem {

    func updatingFinalName(_ newName: String) -> RenameItem {
        RenameItem(
            id: self.id,
            original: self.original,
            editedName: newName,
            source: .manual,
            issues: self.issues
        )
    }
}
