// Logic/NameNormalizer.swift
import Foundation

enum NameNormalizer {

    /// 最小限の正規化のみ行う
    static func normalize(_ input: String) -> NormalizationResult {
        var result = input
        var warnings: [RenameWarning] = []

        // ① 全角スペース → 半角スペース
        if result.contains("　") {
            result = result.replacingOccurrences(of: "　", with: " ")
            warnings.append(.fullWidthSpaceReplaced)
        }

        // ② 連続スペースを1つに畳む
        let collapsed = collapseSpaces(result)
        if collapsed != result {
            result = collapsed
            warnings.append(.multipleSpacesCollapsed)
        }

        return NormalizationResult(
            originalName: input,
            normalizedName: result,
            tokens: [],          // ← ここ重要（後工程で使う）
            warnings: warnings
        )
    }

    /// 連続スペースを1つにする
    private static func collapseSpaces(_ text: String) -> String {
        var output = ""
        var previousWasSpace = false

        for ch in text {
            if ch == " " {
                if !previousWasSpace {
                    output.append(ch)
                }
                previousWasSpace = true
            } else {
                output.append(ch)
                previousWasSpace = false
            }
        }

        return output
    }
}
