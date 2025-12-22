//
// Views/RenameListView.swift
//
import SwiftUI

struct RenameListView: View {

    @State private var items: [RenameItem] = FileScanService.loadSampleNames()
    @State private var editingItem: RenameItem?

    let showSpaceMarkers: Bool

    var body: some View {
        List {
            ForEach(items, id: \.id) { item in
                RenamePreviewRowView(
                    item: item,
                    showSpaceMarkers: showSpaceMarkers,
                    onEdit: { editingItem = item }
                )
            }
        }
        .sheet(item: $editingItem) { item in
            RenameEditView(
                item: item,
                showSpaceMarkers: showSpaceMarkers,
                onApply: { updated in
                    if let index = items.firstIndex(where: { $0.id == updated.id }) {
                        items[index] = updated
                    }
                    editingItem = nil
                },
                onCancel: {
                    editingItem = nil
                }
            )
        }
    }
}
