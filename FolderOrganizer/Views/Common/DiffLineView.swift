// Views/Common/DiffLineView.swift

import SwiftUI

struct DiffLineView: View {

    let tokens: [DiffToken]
    let showSpaceMarkers: Bool

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tokens) { token in
                Text(render(token))
                    .foregroundColor(color(for: token))
            }
        }
    }

    // MARK: - Rendering

    private func render(_ token: DiffToken) -> String {
        let text = String(token.char)

        guard showSpaceMarkers else {
            return text
        }

        return text
            .replacingOccurrences(of: " ", with: "·")
            .replacingOccurrences(of: "　", with: "□")
    }

    private func color(for token: DiffToken) -> Color {
        switch token.operation {
        case .equal:
            return .secondary
        case .insert:
            return .green
        case .delete:
            return .red
        case .replace:
            return .orange
        }
    }
}
