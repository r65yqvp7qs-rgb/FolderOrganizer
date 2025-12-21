//
// Views/Rename/RenameDetailView.swift
//
import SwiftUI

struct RenameDetailView: View {

    let original: String
    let suggested: String

    @Binding var editedText: String

    /// スペース可視化（一覧と同じ挙動）
    let showSpaceMarkers: Bool

    let onResetToSuggested: () -> Void
    let onClose: () -> Void

    // 表示用フォント（Rename Detail 用に固定）
    private let detailFont: Font = .system(
        size: 13,
        weight: .semibold,
        design: .monospaced
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Header
            HStack {
                Text("Rename Preview")
                    .font(.title2)
                    .bold()

                Spacer()

                Button("×") {
                    onClose()
                }
            }

            Divider()

            // MARK: - Original
            VStack(alignment: .leading, spacing: 4) {
                Text("旧")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                SpaceMarkerTextView(
                    original,
                    showSpaceMarkers: showSpaceMarkers,
                    font: .system(size: 12, design: .monospaced)
                )
                .opacity(0.65)
            }

            // MARK: - Edit
            VStack(alignment: .leading, spacing: 8) {
                Text("編集")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("新しい名前を編集…", text: $editedText)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 15))

                Button("提案に戻す") {
                    onResetToSuggested()
                }
                .controlSize(.small)
            }

            // MARK: - New (Diff)
            VStack(alignment: .leading, spacing: 6) {
                Text("新（差分）")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                // 編集中 or suggested を表示対象にする
                let preview = editedText.isEmpty ? suggested : editedText

                // Diff 生成
                let tokens = DiffBuilder.build(
                    old: original,
                    new: preview
                )

                // Diff 表示
                DiffTextView(
                    tokens: tokens,
                    font: detailFont
                )
            }

            Spacer()
        }
        .padding(20)
        .frame(minWidth: 520, minHeight: 420)
        .background(
            Color(nsColor: .windowBackgroundColor)
        )
    }
}
