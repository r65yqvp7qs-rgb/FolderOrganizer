// Views/RenameEditView.swift
import SwiftUI

struct RenameEditView: View {

    /// 初期の元名前（比較・初期値用）
    let original: String

    /// 編集中の文字列（リアルタイム反映）
    @Binding var edited: String

    /// 反映（Enter / 反映ボタン）
    let onCommit: () -> Void

    /// キャンセル（Esc）
    let onCancel: () -> Void

    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 16) {

            Text("名前を編集")
                .font(.headline)

            // ─────────────────────────
            // リアルタイムプレビュー
            // ─────────────────────────
            GroupBox("プレビュー（編集内容が即時反映）") {
                Text(makeAttributedString(edited.isEmpty ? original : edited))
                    .font(.system(size: 15, design: .monospaced))
                    .foregroundColor(AppTheme.colors.newText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .textSelection(.enabled)
            }

            // ─────────────────────────
            // 編集欄
            // ─────────────────────────
            GroupBox("編集") {
                TextEditor(text: $edited)
                    .font(.system(size: 18, design: .monospaced))
                    .frame(minHeight: 120)
                    .padding(6)
                    .background(AppTheme.colors.cardBackground)
                    .cornerRadius(6)
                    .focused($focused)
            }

            HStack {
                Button("キャンセル") {
                    onCancel()
                }

                Spacer()

                Button("反映") {
                    onCommit()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .frame(
            minWidth: 520,
            idealWidth: 600,
            maxWidth: 640
        )
        .frame(minHeight: 380)

        // ─────────────────────────
        // Keyboard
        // ─────────────────────────
        .focusable(true)
        .onAppear { focused = true }

        // Enter = 反映（改行しない）
        .onKeyPress(.return) {
            onCommit()
            return .handled
        }

        // Esc = キャンセル
        .onKeyPress(.escape) {
            onCancel()
            return .handled
        }
    }

    // MARK: - 色付きスペース生成
    private func makeAttributedString(_ text: String) -> AttributedString {
        var result = AttributedString()

        for ch in text {
            if ch == " " {
                var a = AttributedString("␣")
                a.foregroundColor = AppTheme.colors.spaceMarkerHalf
                result.append(a)
            } else if ch == "　" {
                var a = AttributedString("▢")
                a.foregroundColor = AppTheme.colors.spaceMarkerFull
                result.append(a)
            } else {
                result.append(AttributedString(String(ch)))
            }
        }

        return result
    }
}
