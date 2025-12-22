//
// Domain/RenameItem.swift
//
import Foundation

struct RenameItem: Identifiable, Hashable {
    let id: UUID
    var original: String
    var normalized: String
    var edited: String
    var flagged: Bool

    init(
        id: UUID = UUID(),
        original: String,
        normalized: String,
        edited: String = "",
        flagged: Bool
    ) {
        self.id = id
        self.original = original
        self.normalized = normalized
        self.edited = edited
        self.flagged = flagged
    }
}
