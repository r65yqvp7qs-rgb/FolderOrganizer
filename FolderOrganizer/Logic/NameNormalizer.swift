//  Logic/NameNormalizer.swift
import Foundation

/// フォルダ名を正規化するための処理群
struct NameNormalizer {

    /// Public API — これを呼べばすべての処理がかかる
    static func normalize(_ name: String) -> String {
        var result = name

        // 1. 基本の幅・記号などを正規化（スペース / 数字 / 英字）
        result = normalizeWidthAndAscii(result)

        // 2. 丸数字などを 01 / 02 に
        result = normalizeCircledNumbers(result)

        // 3. #1 → 01 など
        result = normalizeHashNumber(result)

        // 4. 〜 / ～ / ~ を 〜 に統一
        result = unifyWaveDashVariants(result)

        // 5. 〜 の前後スペースを調整（サブタイトルっぽいところだけ）
        result = normalizeWaveDashSpacing(result)

        // 6. タイトル - サブタイトル のようなハイフン区切りを整形
        result = normalizeHyphenSubtitle(result)

        // 7. [サークル名 (作者名)] → [作者名] にする
        result = fixAuthorBracket(in: result)

        // 8. メタ情報タグ（[DL版] など）を削除
        result = removeMetaTags(result)

        // 9. スペースの最終整形
        result = cleanSpaces(result)

        return result
    }

    // MARK: - 基本の幅・ASCII 正規化

    /// 全角スペース → 半角スペース
    /// 全角数字・英字 → 半角
    /// その他（カタカナなど）は変更しない
    private static func normalizeWidthAndAscii(_ text: String) -> String {
        var scalars = String.UnicodeScalarView()
        scalars.reserveCapacity(text.unicodeScalars.count)

        for scalar in text.unicodeScalars {
            switch scalar.value {
            case 0x3000: // 全角スペース
                scalars.append(UnicodeScalar(0x20)!)

            // 全角 0-9
            case 0xFF10...0xFF19:
                let v = scalar.value - 0xFF10 + 0x30
                scalars.append(UnicodeScalar(v)!)

            // 全角 A-Z
            case 0xFF21...0xFF3A:
                let v = scalar.value - 0xFF21 + 0x41
                scalars.append(UnicodeScalar(v)!)

            // 全角 a-z
            case 0xFF41...0xFF5A:
                let v = scalar.value - 0xFF41 + 0x61
                scalars.append(UnicodeScalar(v)!)

            default:
                scalars.append(scalar)
            }
        }

        return String(scalars)
    }

    // MARK: - ① → 01 など

    private static func normalizeCircledNumbers(_ text: String) -> String {
        // ①(0x2460)〜⑳(0x2473)
        var result = ""
        result.reserveCapacity(text.count)

        for scalar in text.unicodeScalars {
            let v = scalar.value
            if (0x2460...0x2473).contains(v) {
                let number = Int(v - 0x2460) + 1
                let padded = String(format: "%02d", number)
                result.append(padded)
            } else {
                result.unicodeScalars.append(scalar)
            }
        }
        return result
    }

    // MARK: - #1 → 01 など

    private static func normalizeHashNumber(_ name: String) -> String {
        let pattern = #"#(\d{1,2})"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return name
        }

        var result = name
        let range = NSRange(result.startIndex..<result.endIndex, in: result)

        // マッチを後ろから置き換える
        let matches = regex.matches(in: result, range: range)
        for match in matches.reversed() {
            guard match.numberOfRanges >= 2,
                  let fullRange = Range(match.range(at: 0), in: result),
                  let numRange = Range(match.range(at: 1), in: result)
            else { continue }

            let numStr = String(result[numRange])
            guard let num = Int(numStr), num > 0, num <= 99 else { continue }

            let padded = String(format: "%02d", num)
            result.replaceSubrange(fullRange, with: padded)
        }

        return result
    }

    // MARK: - 〜 / ～ / ~ を統一

    private static func unifyWaveDashVariants(_ text: String) -> String {
        var result = text
        let variants: [Character] = ["~", "～", "﹏", "︲", "︿"] // 代表的な類似記号をいくつか
        for v in variants {
            result = result.replacingOccurrences(of: String(v), with: "〜")
        }
        return result
    }

    // MARK: - 〜 の前後スペースを整える

    /// ルール：
    /// - 1個だけ：直前が数字以外のときだけ「… ◯〜△」のように 〜 の前に半角スペース
    /// - 2個：1個目の前に半角スペース（2個目は末尾の飾りなのでそのまま）
    /// - 半角スペース＋終端 になったら最後のスペースは cleanSpaces で削除される
    private static func normalizeWaveDashSpacing(_ text: String) -> String {
        var chars = Array(text)
        let positions = chars.indices.filter { chars[$0] == "〜" }
        let count = positions.count
        if count == 0 { return text }

        // 1 個または 2 個だけを特別扱い
        if count == 1 {
            let idx = positions[0]
            guard idx > chars.startIndex else { return text }

            let beforeIdx = chars.index(before: idx)
            let before = chars[beforeIdx]

            // 「1〜3」のように前が数字なら触らない
            if before.isNumber { return text }

            // 〜 の直前のスペースを一旦削除
            var work = chars
            var insertIndex = idx
            var i = beforeIdx
            while i >= work.startIndex && work[i] == " " {
                work.remove(at: i)
                insertIndex -= 1
                if i == work.startIndex { break }
                i = work.index(before: i)
            }

            // 半角スペースを 1 つ入れる
            work.insert(" ", at: insertIndex)
            return String(work)
        }

        if count == 2 {
            var work = chars

            // 1つ目の前にスペース（数字のときは無視）
            let first = positions[0]
            if first > work.startIndex {
                let beforeIdx = work.index(before: first)
                let before = work[beforeIdx]
                if !before.isNumber {
                    var insertIndex = first
                    var i = beforeIdx
                    while i >= work.startIndex && work[i] == " " {
                        work.remove(at: i)
                        insertIndex -= 1
                        if i == work.startIndex { break }
                        i = work.index(before: i)
                    }
                    work.insert(" ", at: insertIndex)
                }
            }

            // 2つ目の後ろにスペースを入れても、末尾なら最終的に cleanSpaces で削除されるので
            // ここでは特別なことはしない（体裁が崩れやすいので）
            return String(work)
        }

        // 3つ以上ある場合は安全のため触らない
        return text
    }

    // MARK: - タイトル - サブタイトル のようなハイフン区切り

    /// 数字の範囲 (1-20) はそのまま。
    /// 「文字-文字」だけ「文字 - 文字」に整形する。
    private static func normalizeHyphenSubtitle(_ text: String) -> String {
        let pattern = #"([^\s\d])\s*-\s*([^\s\d])"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return text
        }

        var result = text
        let range = NSRange(result.startIndex..<result.endIndex, in: result)
        let matches = regex.matches(in: result, range: range)

        for match in matches.reversed() {
            guard match.numberOfRanges >= 3,
                  let fullRange = Range(match.range(at: 0), in: result),
                  let leftRange = Range(match.range(at: 1), in: result),
                  let rightRange = Range(match.range(at: 2), in: result)
            else { continue }

            let left = String(result[leftRange])
            let right = String(result[rightRange])
            let replacement = "\(left) - \(right)"
            result.replaceSubrange(fullRange, with: replacement)
        }

        return result
    }

    // MARK: - [サークル名 (作者名)] → [作者名]

    ///
    /// 例:
    ///   "[たつわの里 (タツワイプ)] テリル崩壊..." → "[タツワイプ] テリル崩壊..."
    private static func fixAuthorBracket(in name: String) -> String {
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

        // 作者名（第2キャプチャ）
        let authorRangeNS = match.range(at: 2)
        guard let authorRange = Range(authorRangeNS, in: name) else { return name }
        let author = String(name[authorRange])

        // マッチ全体
        let fullRangeNS = match.range(at: 0)
        guard let fullRange = Range(fullRangeNS, in: name) else { return name }

        // マッチの後ろ（作品タイトルなど）
        let afterStart = fullRange.upperBound
        let after = afterStart < name.endIndex ? String(name[afterStart...]) : ""

        if after.isEmpty {
            return "[\(author)]"
        } else {
            return "[\(author)] \(after)"
        }
    }

    // MARK: - メタタグ削除（[DL版] など）

    private static func removeMetaTags(_ name: String) -> String {
        var result = name

        let pattern = #"(\[[^\]]*\])|(\([^)]*\))"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return name
        }

        let nsRange = NSRange(result.startIndex..<result.endIndex, in: result)
        let matches = regex.matches(in: result, range: nsRange)

        for match in matches.reversed() {
            guard let fullRange = Range(match.range, in: result) else { continue }
            let token = String(result[fullRange])

            let isBracket = token.hasPrefix("[")
            let inner = String(token.dropFirst().dropLast()) // 中身だけ

            let shouldRemove: Bool
            if isBracket {
                shouldRemove = shouldRemoveBracketTag(inner)
            } else {
                shouldRemove = shouldRemoveParenTag(inner)
            }

            guard shouldRemove else { continue }

            // 前後のスペースもできるだけ一緒に消す
            var removeRange = fullRange

            // 前がスペースならそこから
            if removeRange.lowerBound > result.startIndex {
                let beforeIdx = result.index(before: removeRange.lowerBound)
                if result[beforeIdx] == " " {
                    removeRange = beforeIdx..<removeRange.upperBound
                }
            }

            // 後ろがスペースならそこまで
            if removeRange.upperBound < result.endIndex {
                let afterIdx = removeRange.upperBound
                if result[afterIdx] == " " {
                    removeRange = removeRange.lowerBound..<result.index(after: afterIdx)
                }
            }

            result.removeSubrange(removeRange)
        }

        return result
    }

    /// [ ... ] タグの削除判定
    private static func shouldRemoveBracketTag(_ rawInner: String) -> Bool {
        let inner = rawInner.trimmingCharacters(in: .whitespacesAndNewlines)
        if inner.isEmpty { return true }

        // 残したいもの
        if inner == "雑誌" { return false }
        if inner == "無修正" { return false }
        if inner == "中国翻訳" { return false }

        // 完全一致で消すもの
        let exactDelete: Set<String> = [
            "DL版",
            "AI生成",
            "同人CG集",
            "同人誌",
            "FANZA限定版"
        ]
        if exactDelete.contains(inner) { return true }

        // 数字タグ [241106] など
        if inner.range(of: #"^\d{6}$"#, options: .regularExpression) != nil {
            return true
        }

        // [d_470183] など
        if inner.range(of: #"^d_\d+$"#, options: .regularExpression) != nil {
            return true
        }

        // 【完全版】 / 【デジタル特装版】 / 【デジタル版限定おまけ付き】 など
        if inner.contains("完全版") { return true }
        if inner.contains("デジタル特装版") { return true }
        if inner.contains("デジタル版限定おまけ付き") { return true }

        // 上記以外の [ ... ] は
        // サークル名 / 作者名 / その他の重要タグの可能性が高いので残す
        return false
    }

    /// ( ... ) タグの削除判定
    private static func shouldRemoveParenTag(_ rawInner: String) -> Bool {
        let inner = rawInner.trimmingCharacters(in: .whitespacesAndNewlines)
        if inner.isEmpty { return true }

        // 残したいもの
        if inner == "中国翻訳" { return false }
        if inner == "男性視点ver." { return false }
        if inner == "女性視点ver." { return false }

        // 完全一致で消すもの
        let exactDelete: Set<String> = [
            "オリジナル",
            "同人誌",
            "成年コミック",
            "同人CG集"
        ]
        if exactDelete.contains(inner) { return true }

        // (C106) などイベント番号
        if inner.range(of: #"^C\d{2,3}$"#, options: .regularExpression) != nil {
            return true
        }

        return false
    }

    // MARK: - スペース整形

    private static func cleanSpaces(_ name: String) -> String {
        var s = name

        // 全角スペースはすでに normalizeWidthAndAscii で変換済みだが念のため
        s = s.replacingOccurrences(of: "　", with: " ")

        // 多重スペースの整理
        while s.contains("  ") {
            s = s.replacingOccurrences(of: "  ", with: " ")
        }

        // 前後空白を削除
        s = s.trimmingCharacters(in: .whitespacesAndNewlines)

        return s
    }
}
