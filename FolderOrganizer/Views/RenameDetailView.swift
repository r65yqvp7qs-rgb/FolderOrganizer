// Views/RenameDetailView.swift
import SwiftUI

struct RenameDetailView: View {
    let original: String
    let suggested: String

    @Binding var editedText: String

    // ★ スペース可視化（一覧と同じ挙動に揃える）
    let showSpaceMarkers: Bool

    let onResetToSuggested: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Folder Organizer")
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Button("✕") { onClose() }
            }

            Group {
                Text("旧:")
                    .font(.system(size: 12))
                    .opacity(0.8)

                if showSpaceMarkers {
                    Text(SpaceMarkerText.make(original))
                        .font(.system(size: 12, design: .monospaced))
                        .opacity(0.85)
                } else {
                    Text(original)
                        .font(.system(size: 12))
                        .opacity(0.85)
                }

                Text("提案:")
                    .font(.system(size: 12))
                    .opacity(0.8)

                if showSpaceMarkers {
                    Text(SpaceMarkerText.make(suggested))
                        .font(.system(size: 12, design: .monospaced))
                        .opacity(0.85)
                } else {
                    Text(suggested)
                        .font(.system(size: 12))
                        .opacity(0.85)
                }
            }

            HStack {
                Text("編集:")
                    .font(.headline)

                Spacer()

                Button("提案に戻す") {
                    onResetToSuggested()
                }
            }

            TextField("新しい名前を編集…", text: $editedText)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 15))

            Text("新:")
                .font(.system(size: 12))
                .opacity(0.8)

            let preview = editedText.isEmpty ? suggested : editedText
            if showSpaceMarkers {
                Text(SpaceMarkerText.make(preview))
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
            } else {
                Text(preview)
                    .font(.system(size: 13, weight: .semibold))
            }

            Spacer()
        }
        .padding(18)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
