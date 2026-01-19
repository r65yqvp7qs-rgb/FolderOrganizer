// Models/RenameItem.swift
//
// 1行ぶんのリネームデータ
// - RenameItemSource は別ファイルで定義する（重複定義しない）
//

import Foundation

struct RenameItem: Identifiable, Hashable, Codable {

    // MARK: - Identity

    let id: UUID

    // MARK: - Names

    let original: String
    var normalized: String

    // MARK: - Meta

    var source: RenameItemSource
    var issues: Set<RenameIssue>

    // MARK: - Computed

    /// 現在の確定名
    var finalName: String {
        normalized
    }

    /// 旧互換（UI 用）
    var flagged: Bool {
        !issues.isEmpty
    }

    // MARK: - Init

    init(
        id: UUID = UUID(),
        original: String,
        normalized: String,
        source: RenameItemSource = .auto,
        issues: Set<RenameIssue> = []
    ) {
        self.id = id
        self.original = original
        self.normalized = normalized
        self.source = source
        self.issues = issues
    }
}

// MARK: - Immutable Update API

extension RenameItem {

    /// finalName（= normalized）を更新した新しい RenameItem を返す
    func updatingFinalName(_ newName: String) -> RenameItem {
        RenameItem(
            id: self.id,
            original: self.original,
            normalized: newName,
            source: .user,          // ← ここを manual → user に変更
            issues: self.issues
        )
    }
}
