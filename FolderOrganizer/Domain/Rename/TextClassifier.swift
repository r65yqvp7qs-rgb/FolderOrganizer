// FolderOrganizer/Domain/Rename/TextClassifier.swift
//
// 正規化済みテキストを解析し、RenameIssue を検出する
// ・正規化は行わない（NameNormalizer の責務）
// ・現行の RenameIssue 定義（warning / error）に合わせて最小実装
//

import Foundation

enum TextClassifier {

    // MARK: - Public

    /// 正規化済みテキストから issues を検出する
    /// - Note:
    ///   現段階の RenameIssue は .warning / .error のみ。
    ///   ここでは「気になる要素があれば warning」を付与する最小構成とする。
    static func detectIssues(from normalizedText: String) -> Set<RenameIssue> {
        var issues: Set<RenameIssue> = []

        // 何かしら「気になる」要素があれば warning
        if containsBracket(normalizedText) {
            issues.insert(.warning)
        }

        if containsFullWidthSpace(normalizedText) {
            issues.insert(.warning)
        }

        // 将来：error 判定（空/禁止文字など）を足す余地
        return issues
    }

    // MARK: - Private

    private static func containsBracket(_ text: String) -> Bool {
        let patterns = ["[", "]", "(", ")", "（", "）", "【", "】"]
        return patterns.contains { text.contains($0) }
    }

    private static func containsFullWidthSpace(_ text: String) -> Bool {
        text.contains("　")
    }
}
