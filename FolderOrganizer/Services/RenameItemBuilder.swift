// Services/RenameItemBuilder.swift
//
// RenameItem を自動生成するビルダー
// - NameNormalizer による正規化
// - TextClassifier による issue 判定
// - source は必ず .automatic
//

import Foundation

final class RenameItemBuilder {

    // MARK: - Public API

    /// URL 配列から RenameItem を生成
    func build(from urls: [URL]) -> [RenameItem] {
        urls.compactMap { url in
            buildRenameItem(from: url)
        }
    }

    // MARK: - Internal

    /// 単一 URL から RenameItem を生成
    private func buildRenameItem(from url: URL) -> RenameItem? {

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
            source: .automatic,
            issues: issues
        )
    }
}
