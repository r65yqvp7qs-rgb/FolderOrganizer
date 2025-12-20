// Views/RenameEditView.swift
import SwiftUI

struct RenameEditView: View {

    let original: String
    @Binding var edited: String

    let showSpaceMarkers: Bool

    let onCommit: () -> Void
    let onCancel: () -> Void

    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 16) {

            Text("名前を編集")
                .font(.headline)

            GroupBox("プレビュー（編集内容が即時反映）") {
                let preview = edited.isEmpty ? original : edited

                Group {
                    if showSpaceMarkers {
                        Text(SpaceMarkerText.make(preview))
                            .font(.system(size: 15, design: .monospaced))
                    } else {
                        Text(preview)
                            .font(.system(size: 15))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
                .padding(8)
            }

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
                Button("キャンセル") { onCancel() }

                Spacer()

                Button("反映") { onCommit() }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .frame(minWidth: 520, idealWidth: 600, maxWidth: 640)
        .frame(minHeight: 380)
        .focusable(true)
        .onAppear { focused = true }

        .onKeyPress(.return) {
            onCommit()
            return .handled
        }

        .onKeyPress(.escape) {
            onCancel()
            return .handled
        }
    }
}
