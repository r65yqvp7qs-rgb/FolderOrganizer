// FolderOrganizer/Domain/Browse/FolderConfidenceEvaluator.swift
//
// フォルダの役割（SERIES / VOLUME / UNKNOWN）に対する確信度評価
// - Role 判定とは独立した「確からしさ」の評価
// - UI（★表示）は FolderConfidence のみを見る
//

import Foundation

struct FolderConfidenceEvaluator {

    // MARK: - Public

    func evaluate(node: FolderNode, parent: FolderNode?) -> FolderConfidence {
        switch node.roleHint {
        case .volume:
            return evaluateVolume(node: node, parent: parent)
        case .series:
            return evaluateSeries(node: node, parent: parent)
        case .unknown:
            return evaluateUnknown(node: node)
        }
    }

    // MARK: - Volume

    private func evaluateVolume(
        node: FolderNode,
        parent: FolderNode?
    ) -> FolderConfidence {

        var score = 0

        // 名前に巻数らしさがある
        if looksLikeVolumeName(node.name) {
            score += 1
        }

        // ノイズが少ない
        if !hasNoiseInName(node.name) {
            score += 1
        }

        // 親が SERIES
        if parent?.roleHint == .series {
            score += 1
        }

        return confidence(from: score)
    }

    // MARK: - Series

    private func evaluateSeries(
        node: FolderNode,
        parent: FolderNode?
    ) -> FolderConfidence {

        var score = 0

        // --- 既存ロジック ---

        // 子がすべて（またはほぼ）VOLUME
        if let children = node.children {
            let volumeCount = children.filter { $0.roleHint == .volume }.count
            if volumeCount >= 2 {
                score += 1
            }

            // =========================
            // C-2 追加ロジック（最小差分）
            // =========================
            // 子の「大半」が VOLUME かつ confidence >= medium
            let reliableVolumeChildren = children.filter {
                $0.roleHint == .volume && $0.confidence != .low
            }

            if reliableVolumeChildren.count * 2 >= children.count {
                score += 1
            }
        }

        // 自分の名前が巻数っぽくない
        if !looksLikeVolumeName(node.name) {
            score += 1
        }

        // ノイズが少ない
        if !hasNoiseInName(node.name) {
            score += 1
        }

        return confidence(from: score)
    }

    // MARK: - Unknown

    private func evaluateUnknown(
        node: FolderNode
    ) -> FolderConfidence {

        var score = 0

        if !hasNoiseInName(node.name) {
            score += 1
        }

        return confidence(from: score)
    }

    // MARK: - Confidence Mapping

    private func confidence(from score: Int) -> FolderConfidence {
        switch score {
        case 3...:
            return .high
        case 2:
            return .medium
        default:
            return .low
        }
    }

    // MARK: - Heuristics

    private func looksLikeVolumeName(_ name: String) -> Bool {
        VolumeNumberDetector.containsVolumeNumber(in: name)
    }

    private func hasNoiseInName(_ name: String) -> Bool {
        let noiseKeywords: [String] = [
            "DL", "dl",
            "RAW", "raw",
            "zip", "ZIP",
            "manga", "MANGA",
            "info", "INFO",
            "[", "]", "(", ")"
        ]

        return noiseKeywords.contains { name.contains($0) }
    }
}
