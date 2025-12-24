// Logic/DiffBuilder.swift

import Foundation

enum DiffBuilder {

    /// original と modified を比較し、DiffToken 配列を生成
    static func build(original: String, modified: String) -> [DiffToken] {

        let originalChars = Array(original)
        let modifiedChars = Array(modified)

        let maxCount = max(originalChars.count, modifiedChars.count)
        var result: [DiffToken] = []

        for i in 0..<maxCount {
            let o = i < originalChars.count ? originalChars[i] : nil
            let m = i < modifiedChars.count ? modifiedChars[i] : nil

            switch (o, m) {
            case let (o?, m?) where o == m:
                result.append(
                    DiffToken(
                        text: String(m),
                        kind: .same
                    )
                )

            case let (_, m?):
                result.append(
                    DiffToken(
                        text: String(m),
                        kind: .replaced
                    )
                )

            default:
                break
            }
        }

        return result
    }
}
