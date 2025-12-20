// Views/RenamePreviewList.swift
import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    let showSpaceMarkers: Bool
    let onSelect: (Int) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                PreviewListContent(
                    items: $items,
                    selectedIndex: $selectedIndex,
                    showSpaceMarkers: showSpaceMarkers,
                    onSelect: onSelect
                )
            }
            .onChange(of: selectedIndex) { _, newValue in
                guard let idx = newValue, items.indices.contains(idx) else { return }
                withAnimation {
                    proxy.scrollTo(items[idx].id, anchor: .center)
                }
            }
        }
        .background(Color.white.opacity(0.03))
        .cornerRadius(10)
    }
}
