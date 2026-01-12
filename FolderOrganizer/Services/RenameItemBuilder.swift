// Services/RenameItemBuilder.swift
//
// URL から RenameItem を生成する責務
// - NameNormalizer を使用
// - Subtitle / PotentialSubtitle 判定
// - Domain モデルを直接返す
//

import Foundation

final class RenameItemBuilder {

    // MARK: - Public

    func buildRenameItem(from url: URL) -> RenameItem? {

        let originalName = url.lastPathComponent
        guard !originalName.isEmpty else {
            return nil
        }

        // 正規化
        let result = NameNormalizer.normalize(originalName)
        let normalizedName = result.normalized

        // issue 判定
        var issues: Set<RenameIssue> = []

        if TextClassifier.isSubtitle(normalizedName) {
            issues.insert(.subtitle)
        } else if TextClassifier.isPotentialSubtitle(normalizedName) {
            issues.insert(.potentialSubtitle)
        }

        // RenameItem 生成（確定形）
        return RenameItem(
            original: originalName,
            normalized: normalizedName,
            source: .auto,          // ← ★ ここが修正点
            issues: issues
        )
    }
}
