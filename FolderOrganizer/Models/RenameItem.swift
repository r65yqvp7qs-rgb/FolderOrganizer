// Models/RenameItem.swift
//
// 1行分のリネーム情報（Domain の最小単位）
// - 自動 / 手編集 / Import の区別を明示
// - 問題点（subtitle 等）は enum で保持
//

import Foundation

struct RenameItem: Identifiable, Hashable, Codable {

    // MARK: - Identity

    let id: UUID

    // MARK: - Core Names

    let original: String
    var normalized: String

    // MARK: - Origin

    let source: RenameSource

    // MARK: - Issues

    let issues: Set<RenameIssue>

    // MARK: - Computed

    var finalName: String {
        normalized
    }

    var hasIssues: Bool {
        !issues.isEmpty
    }

    // MARK: - Init

    init(
        id: UUID = UUID(),
        original: String,
        normalized: String,
        source: RenameSource,
        issues: Set<RenameIssue> = []
    ) {
        self.id = id
        self.original = original
        self.normalized = normalized
        self.source = source
        self.issues = issues
    }
}
