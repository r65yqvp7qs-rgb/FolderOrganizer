//
//  Views/Rename/Diff/DiffTextView.swift
//
//  Diff 表示専用 View（STEP 3-1 確定版）
//  ・上下並びで比較しやすさ最優先
//  ・元名 / 新名ともに同サイズ
//  ・色のみで役割を分ける
//

import SwiftUI

struct DiffTextView: View {

    let original: String
    let normalized: String

    /// STEP 3-2 用（変更あり判定）
    var hasDiff: Bool {
        original != normalized
    }

    /// 一覧表示用フォント（基準サイズ）
    private let baseFont: Font = .system(size: 15, design: .monospaced)

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {

            // 元の名前（比較用・secondary）
            Text(original)
                .font(baseFont)
                .foregroundColor(.secondary)

            // 変更後の名前（メイン）
            Text(normalized)
                .font(baseFont)
                .foregroundColor(.primary)
        }
    }
}

#if DEBUG
struct DiffTextView_Previews: PreviewProvider {
    static var previews: some View {
        DiffTextView(
            original: "[作者名] 作品タイトル",
            normalized: "作品タイトル"
        )
        .padding()
        .frame(width: 420)
    }
}
#endif
