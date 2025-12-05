import Foundation

struct TextClassifier {

    /// 「〜」で囲まれたサブタイトルを持つかどうか
    static func isSubtitle(_ text: String) -> Bool {
        let unified = text
            .replacingOccurrences(of: "～", with: "〜")
            .replacingOccurrences(of: "~", with: "〜")

        let indices = unified.indices.filter { unified[$0] == "〜" }
        return indices.count >= 2
    }

    /// 「ー」を含んでいて、かつ isSubtitle ではない → 要確認候補
    static func isPotentialSubtitle(_ text: String) -> Bool {
        if isSubtitle(text) { return false }
        return text.contains("ー")
    }
}
