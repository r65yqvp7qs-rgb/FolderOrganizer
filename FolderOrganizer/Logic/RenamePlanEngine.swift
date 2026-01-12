// Logic/RenamePlanEngine.swift
//
// URL 群から RenamePlan を生成する中核エンジン
// - RenameItemBuilder を利用して RenameItem を生成
// - RenamePlanBuilder によって Apply/Undo 単位へまとめる
// - Legacy API も提供（互換用）
//

import Foundation

final class RenamePlanEngine {

    // MARK: - Dependencies

    private let itemBuilder = RenameItemBuilder()
    private let planBuilder = RenamePlanBuilder()

    // MARK: - Init

    init() {}

    // MARK: - New API（推奨）

    func generatePlans(
        urls: [URL],
        targetParentURL: URL
    ) -> [RenamePlan] {

        // URL -> RenameItem? を生成
        let items: [RenameItem] = urls.compactMap { url in
            itemBuilder.buildRenameItem(from: url)
        }

        // 念のため件数を揃える（安全策）
        let count = min(urls.count, items.count)

        return (0..<count).map { index in
            planBuilder.build(
                item: items[index],
                originalURL: urls[index],
                targetParentURL: targetParentURL
            )
        }
    }

    // MARK: - Legacy API（互換）

    func generatePlan(for url: URL) -> RenamePlan {
        let parent = url.deletingLastPathComponent()
        return generatePlans(
            urls: [url],
            targetParentURL: parent
        )[0]
    }
}
