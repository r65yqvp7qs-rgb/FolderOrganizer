import Foundation

struct NameNormalizer {

    // MARK: - 公開 API
    // もとの名前を保持しつつ、表示用の名前を返す
    static func normalize(_ name: String) -> (original: String, displayName: String) {
        var result = name

        // 1. 「(同人誌)」「(成年コミック)」などの先頭カテゴリ削除
        result = removeLeadingCategory(from: result)

        // 2. [サークル名 (作者名)] → [作者名]
        result = fixAuthorBracket(in: result)

        // 3. 後半のタグ削除（オリジナル / DL版 / AI生成 など）
        result = removeTrailingTags(in: result)

        // 4. 全角/半角の統一（今は中身は空）
        result = normalizeCharacterWidth(in: result)

        // 5. 英数字まわりスペース調整（今は中身は空）
        result = fixAlphaNumericSpacing(in: result)

        // 6. サブタイトル記号の整形（〜ABC〜 など、※長音符ーはここでは扱わない）
        result = fixSubtitleMarkers(in: result)

        // 7. スペース二重禁止
        while result.contains("  ") {
            result = result.replacingOccurrences(of: "  ", with: " ")
        }

        return (
            original: name,
            displayName: result.trimmingCharacters(in: .whitespaces)
        )
    }

    // MARK: - 1. 先頭カテゴリ削除
    private static func removeLeadingCategory(from name: String) -> String {
        let patterns = [
            #"^\(同人誌\)\s*"#,
            #"^\(成年コミック\)\s*"#,
            #"^\(同人CG集\)\s*"#,
            #"^\(C\d+\)\s*"#,
            #"^\(メガ秋葉原同人祭\d+\)\s*"#,
        ]

        var result = name
        for p in patterns {
            if let range = result.range(of: p, options: .regularExpression) {
                result.removeSubrange(range)
            }
        }
        return result
    }

    // MARK: - 2. [サークル名 (作者名)] → [作者名]
    private static func fixAuthorBracket(in name: String) -> String {
        // 例: [たつわの里 (タツワイプ)] → [タツワイプ]
        let pattern = #"\[([^()\[\]]+)\s*\(([^()\[\]]+)\)\]"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return name
        }

        let nsRange = NSRange(name.startIndex..<name.endIndex, in: name)
        guard let match = regex.firstMatch(in: name, range: nsRange),
              match.numberOfRanges == 3
        else {
            return name
        }

        // 作者名の Range
        let authorNSRange = match.range(at: 2)
        guard let authorRange = Range(authorNSRange, in: name) else {
            return name
        }
        let author = String(name[authorRange])

        // マッチ全体の Range
        let fullMatchNSRange = match.range(at: 0)
        guard let fullMatchRange = Range(fullMatchNSRange, in: name) else {
            return name
        }

        // タグの直後から末尾まで
        let afterStart = fullMatchRange.upperBound
        let after = String(name[afterStart...])

        return "[\(author)] \(after)"
    }

    // MARK: - 3. タグ削除（オリジナル / DL版 / AI生成 など）
    private static func removeTrailingTags(in name: String) -> String {
        var result = name
        let patterns = [
            #"\s*\(オリジナル\)"#,
            #"\s*\[DL版\]"#,
            #"\s*\[AI生成\]"#,
            #"\s*\(デジタル版限定おまけ付き\)"#
        ]

        for p in patterns {
            if let range = result.range(of: p, options: .regularExpression) {
                result.removeSubrange(range)
            }
        }
        return result
    }

    // MARK: - 4. 全角/半角統一（必要になったら中身を実装）
    private static func normalizeCharacterWidth(in name: String) -> String {
        let s = name
        return s
    }

    // MARK: - 5. 英数字周りスペース調整（必要になったら中身を実装）
    private static func fixAlphaNumericSpacing(in name: String) -> String {
        let s = name
        return s
    }

    // MARK: - 6. サブタイトル記号整形（〜ABC〜 など）
    // ※ここでは「ー」はサブタイトル判定に使わない（あなたの方針どおり）
    private static func fixSubtitleMarkers(in name: String) -> String {
        let s = name
        return s
    }
}
