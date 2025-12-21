//
// Views/Common/SpaceMarkerTextView.swift
//
import SwiftUI

/// スペース可視化対応テキスト表示 View（最終・視認性強化版）
///
/// 表示仕様:
/// - 半角スペース: ␣（太字・orange）
/// - 全角スペース: □（太字・orange）
/// - 通常文字: 呼び出し側指定 font
/// - ON/OFF 切替でもレイアウト不変
/// - Light / Dark 両対応
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
            .font(font) // View 側にも指定（安全策）
    }

    // MARK: - AttributedString builder

    private var renderedText: AttributedString {

        // OFF：そのまま表示
        guard showSpaceMarkers else {
            var plain = AttributedString(text)
            plain.font = font
            return plain
        }

        var result = AttributedString()
        result.font = font

        for character in text {
            switch character {

            // 半角スペース
            case " ":
                var marker = AttributedString("␣")
                marker.font = font.bold()              // ★ 太字
                marker.foregroundColor = .orange.opacity(0.9)
                result.append(marker)

            // 全角スペース
            case "　":
                var marker = AttributedString("□")
                marker.font = font.bold()              // ★ 太字
                marker.foregroundColor = .orange.opacity(0.9)
                result.append(marker)

            // 通常文字
            default:
                var normal = AttributedString(String(character))
                normal.font = font
                result.append(normal)
            }
        }

        return result
    }
}
