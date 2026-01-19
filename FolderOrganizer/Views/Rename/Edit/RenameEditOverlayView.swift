// FolderOrganizer/Views/Rename/Edit/RenameEditOverlayView.swift
//
// 編集専用 Overlay（Finder ライク）
// - Enter: 確定 / Esc: キャンセル
// - 外側クリック: 確定
// - 背景/カード色は AppTheme に定義しない（OS 標準 + opacity で吸収）
// - Text のみ AppTheme.colors.primaryText / secondaryText を使用
//

import SwiftUI
import AppKit

struct RenameEditOverlayView: View {

    // MARK: - Inputs

    let originalName: String

    @Binding var editingText: String
    @Binding var isFocused: Bool

    let onCommit: () -> Void
    let onCancel: () -> Void

    // MARK: - Body

    var body: some View {
        ZStack {
            // 背景（外側クリックで確定）
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture { onCommit() }

            // カード（タップ吸収）
            VStack(alignment: .leading, spacing: 14) {

                Text("名前を変更")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppTheme.colors.primaryText)

                VStack(alignment: .leading, spacing: 6) {
                    Text("旧")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppTheme.colors.secondaryText)

                    Text(originalName)
                        .font(.system(size: 13))
                        .foregroundStyle(AppTheme.colors.secondaryText)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("新（Enter=確定 / Esc=キャンセル）")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppTheme.colors.secondaryText)

                    WrappingNoNewlineTextView(
                        text: $editingText,
                        isFocused: $isFocused,
                        onCommit: onCommit,
                        onCancel: onCancel
                    )
                    .frame(minHeight: 120, maxHeight: 220)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(NSColor.textBackgroundColor))
                            .opacity(0.92)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.black.opacity(0.12), lineWidth: 1)
                    )
                }

                // ボタンは置かない（Finder 風）。ヒントだけ。
                HStack(spacing: 10) {
                    Text("Enter: 確定")
                    Text("Esc: キャンセル")
                    Text("外側クリック: 確定")
                }
                .font(.system(size: 11))
                .foregroundStyle(AppTheme.colors.secondaryText)
            }
            .padding(18)
            .frame(width: 720)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(NSColor.windowBackgroundColor))
                    .opacity(0.96)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black.opacity(0.10), lineWidth: 1)
            )
            .shadow(radius: 18)
            .contentShape(Rectangle())
            .onTapGesture {
                // 背景確定を吸収（何もしない）
            }
        }
    }
}
