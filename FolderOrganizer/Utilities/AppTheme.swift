// Utilities/AppTheme.swift
import SwiftUI
import AppKit

enum AppTheme {
    struct colors {

        // MARK: - 全体背景（ウインドウ背景に合わせる）
        static let background = Color(NSColor.windowBackgroundColor)

        // MARK: - 行背景（通常 / 交互）
        /// 通常行の背景
        static let cardBackground = Color(NSColor.textBackgroundColor)

        /// 交互行（オルタネート行）の背景
        static let rowAltBackground = Color(NSColor.underPageBackgroundColor)

        /// 行の区切り線などに使う薄い線
        static let rowSeparator = Color(NSColor.separatorColor)

        // MARK: - サブタイトル系（将来用）
        /// サブタイトル確定（自動判定 OK）
        static let subtitleBackground =
            Color(NSColor.systemBlue.withAlphaComponent(0.15))

        /// サブタイトル候補（要チェック）
        static let potentialSubtitleBackground =
            Color(NSColor.systemOrange.withAlphaComponent(0.18))

        /// ニュートラルな背景
        static let neutralBackground = cardBackground

        // MARK: - テキスト
        /// アプリタイトルなど
        static let titleText = Color(NSColor.labelColor)

        /// 「旧:」ラベルなど
        static let oldText = Color(NSColor.secondaryLabelColor)

        /// 「新:」ラベルや新タイトル
        static let newText = Color(NSColor.systemBlue)

        /// チェックボックス横のラベルなど
        static let checkLabel = Color(NSColor.tertiaryLabelColor)

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
