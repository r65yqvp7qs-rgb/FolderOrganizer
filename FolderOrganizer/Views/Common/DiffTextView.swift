// Views/Common/DiffTextView.swift

import SwiftUI

struct DiffTextView: View {

    let tokens: [DiffToken]
    let font: Font

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tokens) { token in
                Text(token.text)
                    .font(font)
                    .foregroundStyle(color(for: token.kind))
            }
        }
    }

    private func color(for kind: DiffKind) -> Color {
        switch kind {
        case .same:
            return .secondary
        case .added, .replaced:
            return .accentColor
        }
    }
}
