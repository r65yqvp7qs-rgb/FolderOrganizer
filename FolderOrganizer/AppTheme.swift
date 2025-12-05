import SwiftUI

enum AppTheme {
    enum colors {
        // 画面全体の背景
        static let background = Color(NSColor.windowBackgroundColor)

        // 交互の行背景
        static let rowStripe = Color.white
        static let rowAltStripe = Color(NSColor.windowBackgroundColor).opacity(0.7)

        // サブタイトル判定 OK（〜〜） → 薄い青
        static let subtitle = Color(red: 0.85, green: 0.92, blue: 1.0)

        // 「長音符ありで要確認」 → 薄い黄色
        static let maybeSubtitle = Color(red: 1.0, green: 0.96, blue: 0.85)

        // 新タイトルの文字色
        static let newText = Color(red: 0.0, green: 0.2, blue: 0.6)
    }
}
