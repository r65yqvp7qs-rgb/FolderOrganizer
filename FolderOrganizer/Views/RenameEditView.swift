import SwiftUI
import AppKit

struct RenameEditView: View {

    @Binding var editText: String     // 下段：編集中
    let onCommit: (String) -> Void
    let onCancel: () -> Void

    @FocusState private var isEditorFocused: Bool

    private let editorWidth: CGFloat = 900
    private let editorPadding: CGFloat = 10

    var body: some View {
        ZStack {
            // 背景暗幕
            Color.black.opacity(0.15)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {

                // タイトル
                Text("名前の修正（Esc でキャンセル）")
                    .font(.headline)

                // ─────────────────────────────
                // 上段：リアルタイムプレビュー（スクロールなし）
                // ─────────────────────────────
                Text(attributedPreview(from: editText))
                    .font(.system(size: 20, design: .monospaced))
                    .frame(width: editorWidth, height: 100, alignment: .topLeading)
                    .padding(editorPadding)
                    .background(Color(NSColor.textBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    )
                    .cornerRadius(12)

                // ─────────────────────────────
                // 下段：編集欄（スクロールバーなし）
                // ─────────────────────────────
                TextEditor(text: $editText)
                    .font(.system(size: 20, design: .monospaced))
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.never)        // ← スクロールバー完全オフ
                    .background(Color(NSColor.textBackgroundColor))
                    .foregroundColor(.primary)
                    .frame(width: editorWidth, height: 150)
                    .padding(editorPadding)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppTheme.colors.selectedBorder.opacity(0.8),
                                    lineWidth: 1.4)
                    )
                    .focused($isEditorFocused)
                    .onChange(of: editText) { _, newValue in
                        // フォルダ名なので改行禁止
                        let cleaned = newValue.replacingOccurrences(of: "\n", with: "")
                        if cleaned != newValue {
                            editText = cleaned
                        }
                    }

                // ─────────────────────────────
                // ボタンエリア
                // ─────────────────────────────
                HStack {
                    Spacer()

                    Button("キャンセル") {
                        onCancel()
                    }

                    Button("反映") {
                        onCommit(editText)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding(.top, 5)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 28)
            .background(Color(NSColor.windowBackgroundColor))
            .cornerRadius(20)
            .shadow(radius: 20)
        }
        .onAppear { isEditorFocused = true }
        .onExitCommand { onCancel() }
    }

    // MARK: - カラー付きスペースマーカー表示（上段）

    private func attributedPreview(from text: String) -> AttributedString {
        var result = AttributedString(text)

        // 半角スペース
        while let range = result.range(of: " ") {
            var marker = AttributedString("␣")
            marker.foregroundColor = AppTheme.colors.spaceMarkerHalf
            result.replaceSubrange(range, with: marker)
        }

        // 全角スペース
        while let range = result.range(of: "　") {
            var marker = AttributedString("▢")
            marker.foregroundColor = AppTheme.colors.spaceMarkerFull
            result.replaceSubrange(range, with: marker)
        }

        return result
    }
}
