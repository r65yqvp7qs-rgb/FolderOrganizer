//
//  Domain/Diff/DiffBuilder.swift
//
//  original / normalized の文字単位 Diff を生成
//  ・最小構成（LCS 等は使わない）
//  ・同 index 比較ベース
//  ・将来アルゴリズム差し替え前提
//

import Foundation

enum DiffBuilder {

    /// 文字単位 Diff を生成
    static func build(
        original: String,
        normalized: String
    ) -> (original: [DiffToken], normalized: [DiffToken]) {

        let oChars = Array(original)
        let nChars = Array(normalized)
        let maxCount = max(oChars.count, nChars.count)

        var originalTokens: [DiffToken] = []
        var normalizedTokens: [DiffToken] = []

        for index in 0..<maxCount {
            let oChar = index < oChars.count ? String(oChars[index]) : nil
            let nChar = index < nChars.count ? String(nChars[index]) : nil

            let isDifferent = oChar != nChar

            if let oChar {
                originalTokens.append(
                    DiffToken(
                        character: oChar,
                        isChanged: isDifferent
                    )
                )
            }

            if let nChar {
                normalizedTokens.append(
                    DiffToken(
                        character: nChar,
                        isChanged: isDifferent
                    )
                )
            }
        }

        return (originalTokens, normalizedTokens)
    }
}
