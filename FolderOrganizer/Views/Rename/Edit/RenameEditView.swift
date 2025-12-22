// Views/Rename/Edit/RenameEditView.swift

import SwiftUI

struct RenameEditView: View {

    let item: RenameItem
    let showSpaceMarkers: Bool
    let onApply: (RenameItem) -> Void
    let onCancel: () -> Void

    @State private var editingText: String = ""

    init(
        item: RenameItem,
        showSpaceMarkers: Bool,
        onApply: @escaping (RenameItem) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.item = item
        self.showSpaceMarkers = showSpaceMarkers
        self.onApply = onApply
        self.onCancel = onCancel

        // ★ 表示名は View 側で決定
        _editingText = State(
            initialValue: item.edited.isEmpty
                ? item.normalized
                : item.edited
        )
    }

    var body: some View {
        VStack(spacing: 16) {

            // プレビュー
            VStack(alignment: .leading, spacing: 6) {
                Text("プレビュー")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                SpaceMarkerTextView(
                    editingText,
                    showSpaceMarkers: showSpaceMarkers,
                    font: .system(size: 14, weight: .semibold, design: .monospaced)
                )
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            // 編集
            VStack(alignment: .leading, spacing: 6) {
                Text("編集")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextField("新しい名前", text: $editingText)
                    .textFieldStyle(.roundedBorder)
            }

            Spacer()

            HStack {
                Button("キャンセル") {
                    onCancel()
                }

                Spacer()

                Button("適用") {
                    var updated = item
                    updated.edited = editingText
                    onApply(updated)
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(minWidth: 420, minHeight: 360)
    }
}
