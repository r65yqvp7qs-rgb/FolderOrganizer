//  Views/RenamePreviewList.swift
import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]

                        RenamePreviewRow(
                            original: item.original,
                            normalized: item.normalized,
                            isOdd: index % 2 == 0,
                            isSelected: index == selectedIndex,
                            flagged: $items[index].flagged
                        )
                        .id(index)
                        .contentShape(Rectangle())
                        .onTapGesture { selectedIndex = index }
                    }
                }
                .padding(.horizontal, 48)          // 左右の余白を固定
                .padding(.top, 8)
            }
            .background(AppTheme.colors.background)

            // 選択が変わったら中央あたりにスクロール
            .onChange(of: selectedIndex) { newIndex in
                if let idx = newIndex {
                    withAnimation {
                        proxy.scrollTo(idx, anchor: .center)
                    }
                }
            }
        }
    }
}
