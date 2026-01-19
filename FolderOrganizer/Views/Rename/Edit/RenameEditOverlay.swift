//  Views/Rename/Edit/RenameEditOverlay.swift
//
//  編集 Overlay
//  - 背景クリック：閉じる（commit/cancelは呼ばない）※必要なら後で変えられる
//  - Editor は 2〜3行の見た目（内部スクロール）
//  - Editor は wantsFocus でフォーカス＆末尾カーソル
//

import SwiftUI

struct RenameEditOverlay: View {

    let original: String
    @Binding var text: String
    @Binding var wantsFocus: Bool

    let onCommit: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            // ✅ 背景（ここだけが「外側クリック」を受ける）
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture {
                    // 外側クリックは「閉じる」扱いにするなら cancel
                    onCancel()
                }

            // ✅ パネル本体
            VStack(alignment: .leading, spacing: 10) {

                Text("名前を変更")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 6) {
                    Text("旧")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(original)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("新")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    // ✅ 折り返し対応 Editor（Enter/Esc は中で拾う）
                    RenameTextEditor(
                        text: $text,
                        wantsFocus: $wantsFocus,
                        onCommit: onCommit,
                        onCancel: onCancel
                    )
                    .frame(height: 96) // だいたい 2〜3行ぶん
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Text("Enter: 確定   Esc: キャンセル")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .frame(maxWidth: 740)
            .background(.ultraThickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            // ✅ ここでの swallow gesture は入れない（Editor のクリックを殺しやすい）
        }
    }
}
