// Models/RenamePlan.swift
//
// 1 URL 分の Rename 適用計画（Apply 契約モデル）
// - DryRun / Apply / Undo / Export / Import の共通基盤
// - 旧コード互換のための computed property（destinationURL / normalizedName 等）も提供
//

import Foundation

struct RenamePlan: Identifiable, Hashable, Codable {

    // MARK: - Identity

    let id: UUID

    // MARK: - Target

    /// 元の URL（現在の場所）
    let originalURL: URL

    /// 親ディレクトリ（Apply 時の安全確認用）
    let targetParentURL: URL

    // MARK: - Rename

    /// 名前の差分情報
    let item: RenameItem

    // MARK: - Computed (New)

    /// Apply 後の URL（確定）
    var targetURL: URL {
        targetParentURL.appendingPathComponent(item.finalName)
    }

    /// 実際に名前が変わるか
    var isChanged: Bool {
        originalURL.lastPathComponent != item.finalName
    }

    // MARK: - Legacy compatibility（旧コード救済）

    /// 旧: plan.originalName
    var originalName: String {
        originalURL.lastPathComponent
    }

    /// 旧: plan.normalizedName
    var normalizedName: String {
        item.finalName
    }

    /// 旧: plan.destinationURL
    var destinationURL: URL {
        targetURL
    }

    /// 旧: plan.normalizeResult.warnings を満たすための互換型
    struct LegacyNormalizeResult: Hashable, Codable {
        let warnings: [String]
    }

    /// 旧: plan.normalizeResult
    /// - Note: warnings は issues から生成（必要十分な互換）
    var normalizeResult: LegacyNormalizeResult {
        let warnings: [String] = item.issues
            .map { issue in
                switch issue {
                case .subtitle:
                    return "サブタイトル検出"
                case .potentialSubtitle:
                    return "サブタイトルの可能性"
                }
            }
            .sorted()

        return LegacyNormalizeResult(warnings: warnings)
    }

    // MARK: - Init

    init(
        id: UUID = UUID(),
        originalURL: URL,
        targetParentURL: URL,
        item: RenameItem
    ) {
        self.id = id
        self.originalURL = originalURL
        self.targetParentURL = targetParentURL
        self.item = item
    }
}
