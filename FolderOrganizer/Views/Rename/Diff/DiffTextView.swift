//
//  Views/Rename/Diff/DiffTextView.swift
//
//  Diff 表示専用 View（STEP 3-3）
//  ・上下並び比較
//  ・変更あり行を強調（STEP 3-2）
//  ・スペース可視化 ON/OFF 対応
//

import SwiftUI

struct DiffTextView: View {

    let original: String
    let normalized: String
    let showSpaceMarkers: Bool   // ★ 追加

    /// 変更があるか
    var hasDiff: Bool {
        original != normalized
    }

    /// 表示用テキスト（スペース可視化対応）
    private var originalText: String {
        showSpaceMarkers
        ? SpaceMarker.visualize(original)
        : original
    }

    private var normalizedText: String {
        showSpaceMarkers
        ? SpaceMarker.visualize(normalized)
        : normalized
    }

    /// 非編集時 基準フォント
    private let baseFont: Font = .system(size: 15, design: .monospaced)

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {

            // 元の名前
            Text(originalText)
                .font(baseFont)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            // 変更後の名前
            Text(normalizedText)
                .font(
                    hasDiff
                    ? baseFont.weight(.semibold)
                    : baseFont
                )
                .foregroundColor(
                    hasDiff
                    ? Color.accentColor
                    : Color.primary
                )
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#if DEBUG
struct DiffTextView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            DiffTextView(
                original: "タイトル　テスト",
                normalized: "タイトル テスト",
                showSpaceMarkers: true
            )

            DiffTextView(
                original: "変更なし",
                normalized: "変更なし",
                showSpaceMarkers: false
            )
        }
        .padding()
        .frame(width: 420)
    }
}
#endif
