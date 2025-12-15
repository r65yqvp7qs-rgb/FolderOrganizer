// UI/Diff/DiffBuilder.swift
import SwiftUI
import Foundation

/// Diff表示・スペース可視化など、UI向けの軽量ユーティリティ
enum DiffBuilder {

    // MARK: - Public

    /// old と new の差分を「new 側の文字列」に対して軽くハイライトして返す
    /// - 仕様：同じindex位置で old と異なる文字を「太字 + 緑」にする（簡易diff）
    static func highlightDiff(old: String, new: String) -> Text {
        let oldChars = Array(old)
        let newChars = Array(new)

        var result = Text("")

        for i in 0..<newChars.count {
            let ch = String(newChars[i])
            let isChanged: Bool = {
                guard i < oldChars.count else { return true }
                return oldChars[i] != newChars[i]
            }()

            if isChanged {
                result = result
                    + Text(ch)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
            } else {
                result = result + Text(ch)
            }
        }

        return result
    }

    /// 文字列中の空白を可視化して返す（Text）
    /// - 半角スペース: "␣"
    /// - 全角スペース: "▢"
    /// - タブ: "⇥"
    /// - 改行: "↩︎"（※ここは好みで消してOK）
    static func highlightSpaces(in text: String) -> Text {
        Text(visibleWhitespace(text))
    }

    // MARK: - Internal helper

    /// View以外でも使えるように、可視化済みStringも用意
    static func visibleWhitespace(_ text: String) -> String {
        var out = ""
        out.reserveCapacity(text.count)

        for scalar in text.unicodeScalars {
            switch scalar {
            case " ":
                out.append("␣")     // half-width space
            case "　":
                out.append("▢")     // full-width space
            case "\t":
                out.append("⇥")
            case "\n":
                out.append("↩︎")
            default:
                out.unicodeScalars.append(scalar)
            }
        }

        return out
    }
}
