//
// Views/Common/SpaceMarkerTextView.swift
//
import SwiftUI

struct SpaceMarkerTextView: View {

    private let text: String
    private let showSpaceMarkers: Bool
    private let font: Font

    init(
        _ text: String,
        showSpaceMarkers: Bool,
        font: Font = .system(
            size: 14,
            weight: .semibold,
            design: .monospaced
        )
    ) {
        self.text = text
        self.showSpaceMarkers = showSpaceMarkers
        self.font = font
    }

    var body: some View {
        Text(renderedText)
            .font(font) // ← View 側（保険）
    }

    private var renderedText: AttributedString {
        guard showSpaceMarkers else {
            var plain = AttributedString(text)
            plain.font = font           // ✅ ここ重要
            return plain
        }

        var result = AttributedString()
        result.font = font              // ✅ 全体に先に適用

        for character in text {
            switch character {

            // 半角スペース
            case " ":
                var marked = AttributedString("␣")
                marked.foregroundColor = .orange
                marked.font = font      // ✅ 明示
                result.append(marked)

            // 全角スペース
            case "　":
                var marked = AttributedString("□")
                marked.foregroundColor = .orange
                marked.font = font      // ✅ 明示
                result.append(marked)

            default:
                var normal = AttributedString(String(character))
                normal.font = font      // ✅ 明示
                result.append(normal)
            }
        }

        return result
    }
}
