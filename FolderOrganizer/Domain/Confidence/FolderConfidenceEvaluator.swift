// Domain/Confidence/FolderConfidenceEvaluator.swift
//
// フォルダの確信度を評価するロジック（D-3）
// - roleHint が UNKNOWN の場合のみ理由付きで評価
// - reasons が空の場合でも必ず 1 つ入れる（noRuleMatched）
// - parent は参照するが、FolderNode に保持はしない
//

import Foundation

struct FolderConfidenceEvaluator {

    // MARK: - Public

    /// フォルダ 1 ノード分の確信度を評価する
    func evaluate(
        node: FolderNode,
        parent: FolderNode?
    ) -> FolderConfidence {

        switch node.roleHint {

        case .series:
            // SERIES は将来拡張前提だが、現段階では高確信
            return .high

        case .volume:
            // VOLUME は中確信（子構造や番号一致で将来調整可能）
            return .medium

        case .unknown:
            var reasons = buildUnknownReasons(node: node, parent: parent)

            // D-3 方針：理由が空でも必ず 1 つ入れる
            if reasons.isEmpty {
                reasons = [.noRuleMatched]
            }

            return .unknown(reasons: reasons)
        }
    }

    // MARK: - Unknown Reasons Builder

    private func buildUnknownReasons(
        node: FolderNode,
        parent: FolderNode?
    ) -> [UnknownReason] {

        var reasons: [UnknownReason] = []

        let name = node.name

        // 子を持たないフォルダ
        if node.children == nil || node.children?.isEmpty == true {
            reasons.append(.leafFolder)
        }

        // [DL] / DL版 など
        if name.localizedCaseInsensitiveContains("[DL]") ||
            name.localizedCaseInsensitiveContains("DL版") ||
            name.localizedCaseInsensitiveContains("DL") {
            reasons.append(.containsDLMarker)
        }

        // Episode / 巻数っぽい数字（01, 第01話, 01-03 など）
        if name.range(
            of: #"(\b\d{1,3}\b|第\d{1,3}[話巻])"#,
            options: .regularExpression
        ) != nil {
            reasons.append(.containsEpisodeNumber)
        }

        // 日付っぽい表記（2024-01-01 / 20240101 / 2024_01_01）
        if name.range(
            of: #"\b(19|20)\d{2}([\-_/]?\d{1,2}){1,2}\b"#,
            options: .regularExpression
        ) != nil {
            reasons.append(.containsDateStamp)
        }

        return reasons
    }
}
