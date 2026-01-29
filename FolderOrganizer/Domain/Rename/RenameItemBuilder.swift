// FolderOrganizer/Domain/Rename/RenameItemBuilder.swift
//
// URL から RenameItem を生成し、表示用に「正規化名」も返す Builder
// ・Domain の RenameItem は「original / editedName / finalName」設計なので、
//   正規化名は RenameItem に保持せず（旧設計へ戻らない）、Built に同梱する。
// ・RenamePlan / Diff / Apply には関与しない
//

import Foundation

final class RenameItemBuilder {

    // MARK: - Result Model

    /// Browse/Preview 用の最小コンテナ
    /// - item: Domain の RenameItem（最新定義そのまま）
    /// - normalizedName: 表示用の正規化名（Domain には保持しない）
    struct Built: Identifiable, Hashable {
        let id: UUID
        let item: RenameItem
        let normalizedName: String

        init(item: RenameItem, normalizedName: String) {
            self.id = item.id
            self.item = item
            self.normalizedName = normalizedName
        }
    }

    // MARK: - Public

    func build(from url: URL) -> Built? {
        let originalName = url.lastPathComponent
        guard !originalName.isEmpty else {
            return nil
        }

        // 正規化（表示用）
        let normalizedResult = NameNormalizer.normalize(originalName)
        let normalizedName = normalizedResult.normalized

        // issue 検出（正規化済み文字列に対して行う）
        let issues = TextClassifier.detectIssues(from: normalizedName)

        // Domain モデル生成（最新定義に合わせる）
        let item = RenameItem(
            original: originalName,
            editedName: nil,
            source: .auto,
            issues: issues
        )

        return Built(item: item, normalizedName: normalizedName)
    }
}
