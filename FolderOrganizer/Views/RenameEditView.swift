//  Views/RenameEditView.swift
import SwiftUI

struct RenameEditView: View {

    @Binding var editText: String     // 下段：編集中（新）
    let onCommit: (String) -> Void
    let onCancel: () -> Void

    @FocusState private var isEditorFocused: Bool

    var body: some View {
        ZStack {
            // 背景を少し暗くしてモーダル感だけ出す
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {

                // タイトル
                Text("名前の修正（Esc でキャンセル）")
                    .font(.system(size: 18, weight: .semibold))

                // 上段：リアルタイム・プレビュー（スペースマーカー付き）
                ScrollView {
                    Text(previewText(from: editText))
                        .font(.system(size: 20, weight: .regular, design: .monospaced))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                }
                .frame(minHeight: 70, idealHeight: 90, maxHeight: 110)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .cornerRadius(14)

                // 下段：編集欄（スペースマーカーなし）
                TextEditor(text: $editText)
                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                    .scrollContentBackground(.hidden)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .frame(minHeight: 110, idealHeight: 140, maxHeight: 170)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.blue.opacity(0.6), lineWidth: 1.2)
                    )
                    .focused($isEditorFocused)
                    // 改行禁止（macOS 14 の新 onChange シグネチャ）
                    .onChange(of: editText) { _, newValue in
                        let cleaned = newValue.replacingOccurrences(of: "\n", with: "")
                        if cleaned != newValue {
                            editText = cleaned
                        }
                    }

                HStack(spacing: 16) {
                    Spacer()

                    Button("キャンセル") {
                        onCancel()
                    }
                    .buttonStyle(.bordered)

                    Button("反映") {
                        onCommit(editText)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)   // 少し大きめに
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
            .background(Color(.windowBackgroundColor))   // 白系〜薄グレー
            .cornerRadius(22)
            .shadow(radius: 18)
            .frame(maxWidth: 900)   // 詳細ポップアップよりちょっと狭い想定
        }
        .onAppear {
            isEditorFocused = true
        }
        .onExitCommand {
            onCancel()
        }
    }

    // MARK: - プレビュー用ヘルパー

    /// スペースにマーカーを付けた文字列を生成（半角:␣ / 全角:▢）
    private func previewText(from text: String) -> String {
        text
            .replacingOccurrences(of: " ", with: "␣")
            .replacingOccurrences(of: "　", with: "▢")
    }
}
