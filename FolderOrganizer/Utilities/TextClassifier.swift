import Foundation

struct TextClassifier {

    /// チルダの種類をすべて 〜 にそろえる
    private static func normalizeTilde(_ text: String) -> String {
        var s = text
        s = s.replacingOccurrences(of: "～", with: "〜")
        s = s.replacingOccurrences(of: "~", with: "〜")
        return s
    }

    /// 本命サブタイトル判定： 〜XXX〜 があるか？
    static func isSubtitle(_ text: String) -> Bool {
        let s = normalizeTilde(text)

        guard let first = s.firstIndex(of: "〜"),
              let last  = s.lastIndex(of: "〜"),
              first != last else {
            return false
        }
        // 中身が1文字以上あればサブタイトルとみなす
        return s.index(after: first) < last
    }

    /// 「長音符 ー でサブタイトルっぽいかも」などの
    /// あやしいケースを黄色でハイライトするための判定
    static func isPotentialSubtitle(_ text: String) -> Bool {
        let s = text
        let longDashCount = s.filter { $0 == "ー" }.count
        return longDashCount >= 2
    }
}
