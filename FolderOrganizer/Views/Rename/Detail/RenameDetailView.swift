// Views/Detail/RenameDetailView.swift

import SwiftUI

struct RenameDetailView: View {

    let original: String
    let suggested: String

    @Binding var editedText: String

    /// スペース可視化（一覧と同じ挙動）
    let showSpaceMarkers: Bool

    let onResetToSuggested: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // ヘッダー
            HStack {
                Text("Folder Organizer")
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Button("×") { onClose() }
            }

            // 旧
            Text("旧:")
                .font(.system(size: 12))
                .opacity(0.8)

            SpaceMarkerTextView(
                original,
                showSpaceMarkers: showSpaceMarkers,
                font: showSpaceMarkers
                    ? .system(size: 12, design: .monospaced)
                    : .system(size: 12)
            )
            .opacity(0.85)

            // 編集
            Text("編集:")
                .font(.headline)

            Button("提案に戻す") {
                onResetToSuggested()
            }

            TextField("新しい名前を編集…", text: $editedText)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 15))

            // 新
            Text("新:")
                .font(.system(size: 12))
                .opacity(0.8)

            let preview = editedText.isEmpty ? suggested : editedText

            if showSpaceMarkers {
                SpaceMarkerTextView(
                    preview,
                    showSpaceMarkers: true
                )
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
            } else {
                
                
                let diff = DiffBuilder.build(
                    old: original,
                    new: preview
                )

                DiffTextView(
                    segments: diff,
                    font: .system(size: 13, weight: .semibold, design: .monospaced)
                )
            }

            Spacer()
        }
        .padding(18)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
