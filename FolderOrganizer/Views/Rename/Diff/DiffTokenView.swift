import SwiftUI

struct DiffTokenView: View {

    let token: DiffToken
    let font: Font

    var body: some View {
        Text(token.text)
            .font(font)
            .foregroundStyle(foregroundColor)
            .background(background)
            .underline(isUnderlined, color: underlineColor)
            .overlay(border)
    }

    // MARK: - Style parts

    private var foregroundColor: Color {
        switch token.kind {
        case .same:
            return .primary
        case .added:
            return Color.green.opacity(0.95)
        case .replaced:
            return Color.orange.opacity(0.95)
        }
    }

    private var background: some View {
        Group {
            switch token.kind {
            case .same:
                Color.clear
            case .added:
                Color.green.opacity(0.30)
            case .replaced:
                Color.orange.opacity(0.30)
            }
        }
    }

    private var border: some View {
        Group {
            switch token.kind {
            case .same:
                EmptyView()
            case .added:
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.green.opacity(0.45), lineWidth: 0.8)
            case .replaced:
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.orange.opacity(0.50), lineWidth: 0.8)
            }
        }
    }

    private var isUnderlined: Bool {
        token.kind == .replaced
    }

    private var underlineColor: Color {
        Color.orange.opacity(0.9)
    }
}
