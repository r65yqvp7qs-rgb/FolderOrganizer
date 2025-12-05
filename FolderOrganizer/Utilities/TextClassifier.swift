import Foundation

struct TextClassifier {

    /// サブタイトル確定（〜 / ～）
    static func isSubtitle(_ text: String) -> Bool {
        return text.contains("〜") || text.contains("～")
    }

    /// 長音符による “サブタイトル候補”
    ///
    /// ルール：
    /// - 〜 / ～ を含む場合は本物サブタイトル扱いなのでここでは false
    /// - 「ー」の前後どちらかに半角スペースがある場合だけ true
    ///   例: " ー夏の海ー" → true
    ///   例: "シスターガーデン" → false（単語の一部なので無視）
    static func isPotentialSubtitle(_ text: String) -> Bool {
        // 〜 / ～ があれば isSubtitle 側で扱う
        if isSubtitle(text) { return false }

        let scalars = Array(text.unicodeScalars)
        let count = scalars.count
        guard count > 0 else { return false }

        for i in 0..<count {
            if scalars[i] == "ー".unicodeScalars.first! {
                let prevIsSpace = (i > 0 && scalars[i-1] == " ".unicodeScalars.first!)
                let nextIsSpace = (i < count - 1 && scalars[i+1] == " ".unicodeScalars.first!)
                if prevIsSpace || nextIsSpace {
                    return true   // “ ー ” が単語の外に出ているものだけ怪しい
                }
            }
        }
        return false
    }
}
