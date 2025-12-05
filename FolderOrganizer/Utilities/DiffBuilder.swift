import SwiftUI

enum DiffBuilder {
    static func highlightSpaces(in text: String) -> Text {
        var result = Text("")

        for ch in text {
            if ch == " " {
                let space = Text("␣")
                    .foregroundColor(.red)
                    .bold()
                result = result + space
            } else {
                result = result + Text(String(ch))
            }
        }

        return result
    }
}
