//
//  Views/Rename/Diff/DiffTextView.swift
//
//  Diff 表示専用 View（STEP 3-2）
//  ・上下並びで比較
//  ・変更あり行だけを控えめに強調
//

import SwiftUI

struct DiffTextView: View {

    let original: String
    let normalized: String

    /// 変更があるか
    var hasDiff: Bool {
        original != normalized
    }

    /// 非編集時 基準フォント
    private let baseFont: Font = .system(size: 15, design: .monospaced)

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {

            // 元の名前（比較用）
            Text(original)
                .font(baseFont)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            // 変更後の名前
            Text(normalized)
                .font(
                    hasDiff
                    ? baseFont.weight(.semibold)   // ← 強調
                    : baseFont
                )
                .foregroundColor(
                    hasDiff
                    ? Color.accentColor            // ← 控えめに色を寄せる
                    : Color.primary
                )
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#if DEBUG
struct DiffTextView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 12) {

            DiffTextView(
                original: "[作者名] 作品タイトル",
                normalized: "作品タイトル"
            )

            DiffTextView(
                original: "変更なしタイトル",
                normalized: "変更なしタイトル"
            )
        }
        .padding()
        .frame(width: 420)
    }
}
#endif
