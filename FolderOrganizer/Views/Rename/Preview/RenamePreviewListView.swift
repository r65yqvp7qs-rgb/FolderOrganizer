// Views/Rename/Preview/RenamePreviewListView.swift

import SwiftUI

struct RenamePreviewListView: View {

    @Binding var items: [RenameItem]

    @State private var selectedIndex: Int? = nil
    @State private var isShowingEditor = false

    let showSpaceMarkers: Bool
    let onSelect: (Int) -> Void

    var body: some View {
        List {
            ForEach(items.indices, id: \.self) { index in
                rowView(for: index)
            }
        }
        .listStyle(.plain)
        .sheet(isPresented: $isShowingEditor) {
            if let index = selectedIndex,
               items.indices.contains(index) {

                RenameDetailView(
                    items: items,
                    initialIndex: index
                )

            } else {
                Text("編集対象が見つかりませんでした")
                    .padding()
            }
        }
    }

    // MARK: - Row View（型推論安定用）

    @ViewBuilder
    private func rowView(for index: Int) -> some View {
        RenamePreviewRowView(
            item: items[index],
            showSpaceMarkers: showSpaceMarkers,
            onEdit: {
                selectedIndex = index
                onSelect(index)
                isShowingEditor = true
            }
        )
        .contentShape(Rectangle())
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(
                    selectedIndex == index
                        ? Color.accentColor.opacity(0.55)
                        : Color.clear,
                    lineWidth: 1.5
                )
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
    }
}
