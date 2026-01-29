// FolderOrganizer/Domain/Diff/DiffBuilder.swift
//
// Myers Diff を使って DiffToken を生成（v0.2 正式版）
// - DiffToken は char + operation を持つ struct
//

import Foundation

enum DiffBuilder {

    static func build(
        original: String,
        modified: String
    ) -> (original: [DiffToken], modified: [DiffToken]) {

        let oChars = Array(original)
        let mChars = Array(modified)

        let ops = MyersDiff.diff(old: oChars, new: mChars)

        var oTokens: [DiffToken] = []
        var mTokens: [DiffToken] = []

        var oi = 0
        var mi = 0

        for op in ops {
            switch op {

            case .equal:
                let oChar = oChars[oi]
                let mChar = mChars[mi]

                oTokens.append(DiffToken(char: oChar, operation: .equal))
                mTokens.append(DiffToken(char: mChar, operation: .equal))

                oi += 1
                mi += 1

            case .delete:
                let oChar = oChars[oi]

                oTokens.append(DiffToken(char: oChar, operation: .delete))
                oi += 1

            case .insert:
                let mChar = mChars[mi]

                mTokens.append(DiffToken(char: mChar, operation: .insert))
                mi += 1

            case .replace:
                let oChar = oChars[oi]
                let mChar = mChars[mi]

                oTokens.append(DiffToken(char: oChar, operation: .replace))
                mTokens.append(DiffToken(char: mChar, operation: .replace))

                oi += 1
                mi += 1
            }
        }

        return (oTokens, mTokens)
    }
}
