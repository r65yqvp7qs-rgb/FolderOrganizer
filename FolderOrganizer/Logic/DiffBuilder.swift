//
// Logic/DiffBuilder.swift
//
import Foundation

struct DiffBuilder {

    /// old → new の Rename 用 Diff を生成
    /// - 削除文字は返さない
    /// - 新しい文字のみ same / added / replaced に分類
    static func build(old: String, new: String) -> [DiffToken] {

        var tokens: [DiffToken] = []

        let oldChars = Array(old)
        let newChars = Array(new)

        var oldIndex = 0
        var newIndex = 0

        while newIndex < newChars.count {

            let newChar = newChars[newIndex]

            if oldIndex < oldChars.count {

                let oldChar = oldChars[oldIndex]

                if newChar == oldChar {
                    // 変化なし
                    tokens.append(
                        DiffToken(
                            text: String(newChar),
                            kind: .same
                        )
                    )
                    oldIndex += 1
                    newIndex += 1
                } else {
                    // 置き換え（old の文字は無視、新しい文字だけ表示）
                    tokens.append(
                        DiffToken(
                            text: String(newChar),
                            kind: .replaced
                        )
                    )
                    oldIndex += 1
                    newIndex += 1
                }

            } else {
                // old が尽きた → 追加
                tokens.append(
                    DiffToken(
                        text: String(newChar),
                        kind: .added
                    )
                )
                newIndex += 1
            }
        }

        return tokens
    }
}
