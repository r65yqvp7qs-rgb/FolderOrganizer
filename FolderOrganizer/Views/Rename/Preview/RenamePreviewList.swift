//
//  Views/Rename/Preview/RenamePreviewList.swift
//
//  RenamePlan 一覧 + Inline Edit
//  ・List 非依存
//  ・スクロール常に中央
//  ・編集結果は親へ通知
//  ・スペース可視化フラグを下位へ中継
//

import SwiftUI

struct RenamePreviewList: View {

    // MARK: - Inputs

    let plans: [RenamePlan]
    @Binding var selectionIndex: Int?

    /// スペース可視化（ContentView から受け取る）
    let showSpaceMarkers: Bool

    /// 編集確定（親が実データを書き換える）
    let onCommit: (_ index: Int, _ newName: String) -> Void

    // MARK: - Body

    var body: some View {
        ScrollViewReader { proxy in
            content(proxy: proxy)
                .onChange(of: selectionIndex) { _, newValue in
                    guard let index = newValue else { return }
                    withAnimation(.easeOut(duration: 0.15)) {
                        proxy.scrollTo(index, anchor: .center)
                    }
                }
        }
    }

    // MARK: - Content（型推論を切る）

    @ViewBuilder
    private func content(proxy: ScrollViewProxy) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(plans.indices, id: \.self) { index in
                    row(at: index, proxy: proxy)
                }
            }
            .padding(.vertical, 6)
        }
    }

    // MARK: - Row

    @ViewBuilder
    private func row(at index: Int, proxy: ScrollViewProxy) -> some View {
        RenamePreviewRow(
            plan: plans[index],
            isSelected: selectionIndex == index,
            showSpaceMarkers: showSpaceMarkers,   // ← ★ 追加（素通し）
            onCommit: { newName in
                onCommit(index, newName)
                selectionIndex = nil        // ← Enterで一覧に戻る
            },
            onCancel: {
                // Esc：選択解除（位置は保持）
                selectionIndex = nil
            }
        )
        .id(index)
        .contentShape(Rectangle())
        .onTapGesture {
            select(index, proxy: proxy)
        }
    }

    // MARK: - Selection

    private func select(_ index: Int, proxy: ScrollViewProxy) {
        selectionIndex = index
        withAnimation(.easeOut(duration: 0.15)) {
            proxy.scrollTo(index, anchor: .center)
        }
    }
}
