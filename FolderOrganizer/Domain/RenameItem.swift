//
// Domain/RenameItem.swift
//
import Foundation

struct RenameItem: Identifiable, Hashable {

    let id: UUID
    let original: String
    let normalized: String
    var edited: String
    var flagged: Bool

    /// 一覧表示用の最終表示名
    var displayNameForList: String {
        edited.isEmpty ? normalized : edited
    }

    /// 変更が入っているか
    var isModified: Bool {
        !edited.isEmpty && edited != normalized
    }
}
