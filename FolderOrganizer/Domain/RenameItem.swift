// Domain/RenameItem.swift
import Foundation

/// リネーム対象 1 件
struct RenameItem: Identifiable, Hashable {
    let id: UUID
    let original: String
    let normalized: String
    var flagged: Bool

    init(
        id: UUID = UUID(),
        original: String,
        normalized: String,
        flagged: Bool = false
    ) {
        self.id = id
        self.original = original
        self.normalized = normalized
        self.flagged = flagged
    }
}
