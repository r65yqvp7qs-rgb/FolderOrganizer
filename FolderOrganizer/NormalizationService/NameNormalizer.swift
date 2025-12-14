// NameNormalizer.swift
import Foundation

struct NameNormalizer {

    static func normalize(_ name: String) -> NormalizationResult {

        let normalized = name
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // 🔧 今は最小構成
        let tokens = normalized.split(separator: " ").map(String.init)

        let title = normalized
        let maybeSubtitle: String? = nil

        var warnings: [RenameWarning] = []

        // 仮ルール
        if maybeSubtitle != nil {
            warnings.append(.ambiguousSubtitle(maybeSubtitle!))
        }

        return NormalizationResult(
            originalName: name,
            normalizedName: normalized,
            tokens: tokens,
            author: nil,
            title: title,
            subtitle: nil,
            maybeSubtitle: maybeSubtitle,
            warnings: warnings
        )
    }
}
