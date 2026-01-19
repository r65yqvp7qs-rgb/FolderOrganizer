// FolderOrganizer/Views/Rename/Preview/RenamePreviewList.swift
//
// プレビュー一覧
// - 行全体クリックで選択できる（contentShape）
// - ダブルクリックで編集へ
// - selectedIndex 変化で scrollTo（中心へ寄せる）
// - SwiftUI の type-check 爆発を避けるため、行Viewを関数へ分割する
//

import SwiftUI
import AppKit

struct RenamePreviewList: View {

    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    let onSelect: (Int) -> Void
    let onEditRequest: (Int) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(items.indices, id: \.self) { index in
                        rowView(index: index)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            // AppTheme に依存しない（＝ここでビルドが壊れない）背景
            .background(Color(NSColor.windowBackgroundColor).opacity(0.01))
            .onChange(of: selectedIndex) { _, newValue in
                scrollToSelected(proxy: proxy, index: newValue)
            }
        }
    }

    // MARK: - Row

    @ViewBuilder
    private func rowView(index: Int) -> some View {
        let item = items[index]
        let isSelected = (index == selectedIndex)
        let isChanged = (item.original != item.normalized)

        RenamePreviewRow(
            original: item.original,
            normalized: item.normalized,
            isSelected: isSelected,
            isChanged: isChanged
        )
        .id(index)
        .contentShape(Rectangle()) // 行全体を当たり判定にする

        // ダブルクリックを優先（= 2回目で確実に編集へ）
        .highPriorityGesture(
            TapGesture(count: 2).onEnded {
                onEditRequest(index)
            }
        )

        // シングルクリックは選択
        .simultaneousGesture(
            TapGesture(count: 1).onEnded {
                onSelect(index)
            }
        )
    }

    // MARK: - Scroll

    private func scrollToSelected(proxy: ScrollViewProxy, index: Int?) {
        guard let idx = index else { return }
        withAnimation(.easeOut(duration: 0.12)) {
            proxy.scrollTo(idx, anchor: .center)
        }
    }
}
