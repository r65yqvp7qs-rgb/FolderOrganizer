import Foundation

/// RenamePlan を生成するエンジン（DryRunの心臓）
///
/// STEP C-1 目的:
/// - Engine 内で「正規化済み文字列」を String として直に扱わない
/// - 必ず NormalizationResult を起点にして、必要な String は `.normalizedName` から取り出す
final class RenamePlanEngine {

    init() {}

    /// 既存コードがこのシグネチャで呼んでいる前提
    func generatePlan(
        for url: URL,
        subtitleDecision: UserSubtitleDecision,
        authorDecision: UserAuthorDecision
    ) -> RenamePlan {

        // MARK: - Original
        let originalName = url.lastPathComponent

        // MARK: - Normalize（ここが未配線だとずっと変わらない）
        // ✅ ここで必ず NormalizationResult を受け取る
        let normalization = NameNormalizer.normalize(originalName)

        // ✅ Engine 内の "正規化済み名前" は normalization.normalizedName からのみ取得する
        let normalizedName = normalization.normalizedName

        // MARK: - Detect（最小：今は未実装でもOK）
        // ※ author/title/subtitle/maybeSubtitle の本実装は STEP C-2 / C-3 で設計して組み直す
        let detectedAuthor: String? = nil

        // NOTE:
        // title は暫定で normalizedName を入れておく（後で RoleDetectionResult から組み立てる）
        let title = normalizedName
        let subtitle: String? = nil
        let maybeSubtitle: String? = nil

        // MARK: - Target
        // ✅ 今回の段階では親フォルダは変えない（作者フォルダ作成・移動は後段）
        let targetParentFolder = url.deletingLastPathComponent()

        // ✅ “targetName” も normalizedName から作る（いったん Debug パッチを噛ませる）
        let targetName = DebugNormalizationPatch.applyToTargetName(normalizedName)

        // MARK: - Warnings
        // ✅ warnings は「正規化時に出た警告」＋「検出結果に基づく警告」を合成する
        var warnings: [RenameWarning] = normalization.warnings

        if detectedAuthor == nil {
            warnings.append(.authorNotDetected)
        }

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
