import Foundation

struct NormalizationResult {

    // MARK: - Raw
    let originalName: String
    let normalizedName: String

    // MARK: - Tokens
    let tokens: [String]

    // MARK: - Detected Roles
    let author: String?
    let title: String
    let subtitle: String?
    let maybeSubtitle: String?

    // MARK: - Diagnostics
    let warnings: [RenameWarning]

    // MARK: - Convenience

    /// UI / 旧コード / Export 用の「最終的な名前」
    /// ⚠️ ここ以外で normalizedName を直接使わない
    var displayName: String {
        normalizedName
    }

    /// Apply をブロックすべきか
    var hasBlockingWarning: Bool {
        warnings.contains { $0.isBlocking }
    }
}
