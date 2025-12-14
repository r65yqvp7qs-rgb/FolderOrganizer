// Utilities/AppTheme.swift
import SwiftUI
import AppKit

/// アプリ全体の色・見た目の統一ポイント
///
/// ✅ ここにまとめておくと、
/// - 「存在しない色名参照」
/// - 「Viewごとに色がバラバラ」
/// を防げます。
enum AppTheme {
    struct colors {

        // MARK: - 全体背景（ウインドウ背景に合わせる）
        static let background = Color(NSColor.windowBackgroundColor)

        // MARK: - 行背景（通常 / 交互）
        /// 通常行の背景（文字編集領域にも馴染む）
        static let cardBackground = Color(NSColor.textBackgroundColor)

        /// 交互行（オルタネート行）の背景
        static let rowAltBackground = Color(NSColor.underPageBackgroundColor)

        // MARK: - Subtitle系
        /// subtitle 判定時の背景
        static let subtitleBackground = Color(NSColor.systemYellow).opacity(0.18)

        /// potential subtitle 判定時の背景（subtitleより弱め）
        static let potentialSubtitleBackground = Color(NSColor.systemOrange).opacity(0.14)

        // MARK: - テキスト色
        static let titleText = Color(NSColor.labelColor)

        static let oldText = Color(NSColor.secondaryLabelColor)
        static let newText = Color(NSColor.labelColor)

        // MARK: - ラベル色
        static let subtitleLabel = Color(NSColor.systemOrange)
        static let checkLabel = Color(NSColor.tertiaryLabelColor)

        // MARK: - ボタン・アクセント
        /// プライマリ操作（閉じる/移動/編集など）の色
        /// ※ macOS のアクセントカラーに追従
        static let primaryButton = Color(NSColor.controlAccentColor)

        /// 「maybe subtitle」の強調に使う場合の色（必要なら今後追加用途）
        static let potentialSubtitleStrong = Color(NSColor.systemOrange)

        // MARK: - スペースマーカー
        /// 半角スペース用表示色
        static let spaceMarkerHalf = Color(NSColor.systemRed)

        /// 全角スペース用表示色
        static let spaceMarkerFull = Color(NSColor.systemBlue)

        // MARK: - 行選択枠
        /// 選択されている行の枠線色
        static let selectedBorder = Color(NSColor.controlAccentColor)
    }
}
