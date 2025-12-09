//
//  NameNormalizer.swift
//

import Foundation

struct NameNormalizer {

    // MARK: - Public API
    static func normalize(_ name: String) -> String {
        var s = name

        // 1) スペース、数字、英字を半角に
        s = normalizeASCIIWidth(s)

        // 2) カタカナは全角に統一
        s = normalizeKatakana(s)

        // 3) 丸数字 → 01〜09
        s = normalizeCircledNumbers(s)

        // 4) "〜" の統一（~ ～ ∼ → 〜）
        s = normalizeTildeVariants(s)

        // 5) "〜" 前後スペース調整
        s = normalizeTildeSpacing(s)

        // 6) ハイフン区切りのサブタイトル整理
        s = normalizeHyphenSubtitle(s)

        // 7) 不要タグ削除（[雑誌] は残す）
        s = removeTags(s)

        // 8) スペース整理（連続スペース、前後トリム）
        s = cleanSpaces(s)

        return s
    }

    // MARK: -------------------------------------------------------------
    // 1. ASCII 幅統一（スペース / 数字 / 英字）
    // -------------------------------------------------------------

    private static func normalizeASCIIWidth(_ s: String) -> String {
        s.applyingTransform(.fullwidthToHalfwidth, reverse: false) ?? s
    }

    // MARK: -------------------------------------------------------------
    // 2. カタカナは全角に統一
    // -------------------------------------------------------------

    private static func normalizeKatakana(_ s: String) -> String {
        s.applyingTransform(.hiraganaToKatakana, reverse: false) ?? s
    }

    // MARK: -------------------------------------------------------------
    // 3. 丸数字 → 01〜09
    // -------------------------------------------------------------

    private static func normalizeCircledNumbers(_ s: String) -> String {
        var result = s
        let map: [Character: String] = [
            "①": "01","②": "02","③": "03","④": "04","⑤": "05",
            "⑥": "06","⑦": "07","⑧": "08","⑨": "09"
        ]
        for (key, rep) in map {
            result = result.replacingOccurrences(of: String(key), with: rep)
        }
        return result
    }

    // MARK: -------------------------------------------------------------
    // 4. "~" などを "〜" に統一
    // -------------------------------------------------------------

    private static func normalizeTildeVariants(_ s: String) -> String {
        var result = s
        for v in ["~", "～", "∼"] {
            result = result.replacingOccurrences(of: v, with: "〜")
        }
        return result
    }

    // MARK: -------------------------------------------------------------
    // 5. "〜" の前後スペースのルール適用
    // -------------------------------------------------------------

    private static func normalizeTildeSpacing(_ s: String) -> String {
        var text = s
        let tilde: Character = "〜"
        let indexes = text.indices.filter { text[$0] == tilde }

        guard !indexes.isEmpty else { return text }

        // 1個だけ
        if indexes.count == 1 {
            let idx = indexes[0]
            var start = idx

            while start > text.startIndex,
                  text[text.index(before: start)] == " " {
                start = text.index(before: start)
            }

            text.removeSubrange(start..<idx)
            text.insert(" ", at: start)
        } else {
            // 2個以上
            let first = indexes.first!
            var start = first
            while start > text.startIndex,
                  text[text.index(before: start)] == " " {
                start = text.index(before: start)
            }
            text.removeSubrange(start..<first)
            text.insert(" ", at: start)

            // 文字列が変わったので最後の位置を再取得
            let newIndexes = text.indices.filter { text[$0] == tilde }
            let last = newIndexes.last!

            // 後ろのスペース削除
            var after = text.index(after: last)
            while after < text.endIndex, text[after] == " " {
                text.remove(at: after)
            }

            // 行末でなければスペースを挿入
            if last < text.index(before: text.endIndex) {
                text.insert(" ", at: text.index(after: last))
            }
        }

        // 末尾スペースは削除
        while text.last == " " {
            text.removeLast()
        }

        return text
    }

    // MARK: -------------------------------------------------------------
    // 6. ハイフン区切りサブタイトルの整形
    // 「タイトル - サブタイトル」→「タイトル – サブタイトル」
    // -------------------------------------------------------------

    private static func normalizeHyphenSubtitle(_ s: String) -> String {
        var text = s

        // 正規表現で "タイトル - サブタイトル" を抽出
        let pattern = #"(.+?)\s*[-‐—―]\s*(.+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return text
        }

        let nsText = text as NSString
        let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsText.length))

        guard let first = matches.first, first.numberOfRanges >= 3 else {
            return text
        }

        let title = nsText.substring(with: first.range(at: 1))
        let subtitle = nsText.substring(with: first.range(at: 2))

        // TextClassifier を使って "サブタイトルっぽい" なら置換
        if TextClassifier.isSubtitle(subtitle) {
            text = "\(title) – \(subtitle)"
        }

        return text
    }

    // MARK: -------------------------------------------------------------
    // 7. 不要タグ削除（[雑誌] は保護）
    // -------------------------------------------------------------

    private static func removeTags(_ name: String) -> String {
        var text = name

        let removable = [
            "(DL版)", "(オリジナル)", "DL版", "オリジナル",
            "[AI生成]", "(AI生成)"
        ]

        for tag in removable {
            text = text.replacingOccurrences(of: tag, with: "")
        }

        // [雑誌] 以外の [] タグを取り除く
        let bracketPattern = #"\[(?!雑誌)([^\]]+)\]"#
        if let regex = try? NSRegularExpression(pattern: bracketPattern) {
            text = regex.stringByReplacingMatches(
                in: text,
                range: NSRange(location: 0, length: (text as NSString).length),
                withTemplate: ""
            )
        }

        return text
    }

    // MARK: -------------------------------------------------------------
    // 8. スペース整形（前後 / 連続スペース）
    // -------------------------------------------------------------

    private static func cleanSpaces(_ s: String) -> String {
        var text = s
        while text.contains("  ") {
            text = text.replacingOccurrences(of: "  ", with: " ")
        }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
