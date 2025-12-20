// Views/PreviewRow.swift
import SwiftUI

struct PreviewRow: View {
    let item: RenameItem
    let index: Int
    let isSelected: Bool

    let showSpaceMarkers: Bool
    @Binding var flagged: Bool

    let onSelect: () -> Void

    var body: some View {
        RenamePreviewRowView(
            item: item,
            index: index,
            isSelected: isSelected,
            showSpaceMarkers: showSpaceMarkers,
            flagged: $flagged,
            onSelect: onSelect
        )
        .id(item.id)
    }
}
