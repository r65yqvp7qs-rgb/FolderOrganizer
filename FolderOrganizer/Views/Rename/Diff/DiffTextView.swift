import SwiftUI

struct DiffTextView: View {

    let tokens: [DiffToken]
    let font: Font

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tokens) { token in
                DiffTokenView(token: token, font: font)
            }
        }
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
    }
}
