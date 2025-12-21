//
// Views/Common/DiffTextView.swift
//
import SwiftUI

/// Rename 用 Diff 表示 View
///
/// 表示ルール:
/// - same      : 通常表示
/// - added     : 太字 + 緑
/// - replaced  : 太字 + オレンジ
///
/// 特徴:
/// - ライト / ダークで色を自動調整
/// - 削除文字は表示しない
/// - SpaceMarker（␣ / □）とも共存可能
struct DiffTextView: View {

    let tokens: [DiffToken]
    let font: Font

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Text(renderedText)
            .font(font) // 念のため View 側にも指定
    }

    // MARK: - AttributedString builder

    private var renderedText: AttributedString {
        var result = AttributedString()
        result.font = font

        for token in tokens {
            var part = AttributedString(token.text)

            switch token.kind {

            case .same:
                part.font = font
                // 色指定なし（.primary に委ねる）

            case .added:
                part.font = font.bold()
                part.foregroundColor = addedColor

            case .replaced:
                part.font = font.bold()
                part.foregroundColor = replacedColor
            }

            result.append(part)
        }

        return result
    }

    // MARK: - Colors (Light / Dark)

    /// 追加文字の色
    private var addedColor: Color {
        colorScheme == .light
            ? Color.green.opacity(0.7)
            : Color.green
    }

    /// 置き換え文字の色
    private var replacedColor: Color {
        colorScheme == .light
            ? Color.orange.opacity(0.8)
            : Color.orange
    }
}
