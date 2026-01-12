// Logic/RenamePlanEngine.swift
//
// URL 群から RenamePlan を生成する中核エンジン
// - 新API：generatePlans(urls:targetParentURL:)
// - 旧互換：generatePlan(for:)
//

import Foundation

final class RenamePlanEngine {

    init() {}

    private let itemBuilder = RenameItemBuilder()
    private let planBuilder = RenamePlanBuilder()

    // MARK: - New API（推奨）

    func generatePlans(
        urls: [URL],
        targetParentURL: URL
    ) -> [RenamePlan] {

        let items = itemBuilder.build(from: urls)
        let count = min(urls.count, items.count)

        return (0..<count).map { i in
            planBuilder.build(
                item: items[i],
                originalURL: urls[i],
                targetParentURL: targetParentURL
            )
        }
    }

    // MARK: - Legacy API（互換）

    func generatePlan(for url: URL) -> RenamePlan {
        let parent = url.deletingLastPathComponent()
        return generatePlans(urls: [url], targetParentURL: parent)[0]
    }
}
