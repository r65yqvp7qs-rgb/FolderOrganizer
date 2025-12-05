import SwiftUI

struct AppTheme {
    struct ColorSet {
        let background: Color
        let card: Color
        let cardAlt: Color
        let cardFlagged: Color
        let oldText: Color
        let newText: Color
        let accent: Color
        let border: Color
    }
    
    static let colors = ColorSet(
        background: Color(red: 0.95, green: 0.96, blue: 0.98),          // 全体背景：ごく薄いグレー
        card: Color.white,                                             // カード背景（偶数行）
        cardAlt: Color(red: 0.96, green: 0.97, blue: 0.99),            // カード背景（奇数行）
        cardFlagged: Color(red: 1.0, green: 0.97, blue: 0.80),         // おかしい？ON の行
        oldText: Color(red: 0.40, green: 0.42, blue: 0.48),            // 旧名テキスト
        newText: Color(red: 0.12, green: 0.32, blue: 0.86),            // 新名テキスト（青）
        accent: Color(red: 0.15, green: 0.27, blue: 0.55),             // タイトルなど
        border: Color(red: 0.86, green: 0.88, blue: 0.92)              // 区切り線
    )
}
