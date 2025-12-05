//  Utilities/DiffBuilder.swift

import SwiftUI

struct DiffBuilder {

    /// 半角スペースを ␣ に置換して赤・太字で表示する
    static func highlightSpaces(in text: String) -> Text {
        var result = Text("")

        for ch in text {
            if ch == " " {
                result = result + Text("␣")
                    .bold()
                    .foregroundColor(.red)   // ★ 赤文字・太字
            } else {
                result = result + Text(String(ch))
            }
        }

        return result
    }
}
