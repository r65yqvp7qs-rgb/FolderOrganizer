//
//  Domain/Diff/DiffBuilder.swift
//
//  Myers Diff を使って DiffToken を生成
//

import Foundation

enum DiffBuilder {

    static func build(
        original: String,
        normalized: String
    ) -> (original: [DiffToken], normalized: [DiffToken]) {

        let oChars = Array(original)
        let nChars = Array(normalized)

        let ops = MyersDiff.diff(old: oChars, new: nChars)

        var originalTokens: [DiffToken] = []
        var normalizedTokens: [DiffToken] = []

        var oIndex = 0
        var nIndex = 0

        for op in ops {
            switch op {
            case .equal:
                originalTokens.append(
                    DiffToken(
                        character: String(oChars[oIndex]),
                        operation: .equal
                    )
                )
                normalizedTokens.append(
                    DiffToken(
                        character: String(nChars[nIndex]),
                        operation: .equal
                    )
                )
                oIndex += 1
                nIndex += 1

            case .delete:
                originalTokens.append(
                    DiffToken(
                        character: String(oChars[oIndex]),
                        operation: .delete
                    )
                )
                oIndex += 1

            case .insert:
                normalizedTokens.append(
                    DiffToken(
                        character: String(nChars[nIndex]),
                        operation: .insert
                    )
                )
                nIndex += 1
            }
        }

        return (originalTokens, normalizedTokens)
    }
}
