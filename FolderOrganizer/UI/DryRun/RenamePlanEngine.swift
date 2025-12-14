import Foundation

/// RenamePlan を生成するエンジン（DryRunの心臓）
final class RenamePlanEngine {

    init() {}

    func generatePlan(
        for url: URL,
        userDecision: UserSubtitleDecision
    ) -> RenamePlan {

        // MARK: - Original
        let originalName = url.lastPathComponent

        // MARK: - Normalize（Result型）
        let normalizationResult = NameNormalizer.normalize(originalName)
        let normalizedName = normalizationResult.displayName

        // MARK: - Detect（最小構成：後で役割検出に差し替え）
        let detectedAuthor: String? = normalizationResult.author
        let title: String = normalizationResult.title
        let subtitle: String? = normalizationResult.subtitle
        let maybeSubtitle: String? = normalizationResult.maybeSubtitle

        // MARK: - Target
        let targetParentFolder = url.deletingLastPathComponent()

        // 確認用パッチ（String を渡す）
        let targetName = DebugNormalizationPatch
            .applyToTargetName(normalizedName)

        // MARK: - Warnings
        var warnings: [RenameWarning] = normalizationResult.warnings

        // MARK: - Build Plan
        return RenamePlan(
            originalURL: url,
            originalName: originalName,
            normalizedName: normalizedName,
            detectedAuthor: detectedAuthor,
            title: title,
            subtitle: subtitle,
            maybeSubtitle: maybeSubtitle,
            targetParentFolder: targetParentFolder,
            targetName: targetName,
            warnings: warnings
        )
    }
}
