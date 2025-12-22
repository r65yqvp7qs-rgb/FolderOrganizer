//
// Views/Rename/Preview/PreviewListContentView.swift
// 【新規】Preview 一覧本体
//
import SwiftUI

/// 旧 PreviewListContent（互換用）
struct PreviewListContentView: View {

    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    let showSpaceMarkers: Bool
    let onSelect: (Int) -> Void

    var body: some View {
        LazyVStack(spacing: 6) {
            ForEach(Array(items.indices), id: \.self) { index in
                PreviewRowView(
                    item: items[index],
                    index: index,
                    isSelected: selectedIndex == index,
                    showSpaceMarkers: showSpaceMarkers,
                    flagged: $items[index].flagged,
                    onSelect: { onSelect(index) }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
