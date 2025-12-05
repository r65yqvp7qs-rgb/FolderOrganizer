// Views/RenamePreviewList.swift
import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    var body: some View {
        GeometryReader { geo in   // ← ここ重要！
            let fullWidth = geo.size.width - 40    // 左右マージン20ずつ
            let rowWidth = fullWidth - 24          // Row 内側パディングを引く

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {

                        ForEach(items.indices, id: \.self) { index in
                            RenamePreviewRow(
                                original: items[index].original,
                                normalized: items[index].normalized,
                                isOdd: index % 2 == 0,
                                isSelected: index == selectedIndex,
                                flagged: $items[index].flagged,
                                contentWidth: rowWidth      // ← 追加
                            )
                            .id(index)
                            .contentShape(Rectangle())
                            .onTapGesture { selectedIndex = index }
                            .frame(width: fullWidth)      // ← Row の外側幅を完全固定
                        }
                    }
                    .frame(width: fullWidth)
                    .padding(.horizontal, 20)
                }
                .onChange(of: selectedIndex) { newIndex in
                    if let idx = newIndex {
                        withAnimation { proxy.scrollTo(idx, anchor: .center) }
                    }
                }
            }
        }
    }
}
