// Views/PreviewListContent.swift
import SwiftUI

struct PreviewListContent: View {
    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    let showSpaceMarkers: Bool
    let onSelect: (Int) -> Void

    var body: some View {
        LazyVStack(spacing: 6) {
            ForEach(Array(items.indices), id: \.self) { index in
                PreviewRow(
                    item: items[index],
                    index: index,
                    isSelected: selectedIndex == index,
                    showSpaceMarkers: showSpaceMarkers,
                    flagged: $items[index].flagged,
                    onSelect: {
                        onSelect(index)
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
