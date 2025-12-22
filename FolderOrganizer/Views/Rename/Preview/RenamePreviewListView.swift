//
// Views/Rename/RenamePreviewListView.swift
//
import SwiftUI

/// 変換プレビュー一覧（Card 表示の Row を並べる）
/// - items: RenameItem の配列（Binding）
/// - selectedIndex: 選択中 index（Binding）
/// - showSpaceMarkers: スペース可視化 ON/OFF
/// - onSelect: 行タップ時に呼ばれる（外側で selectedIndex 更新などに使う）
struct RenamePreviewListView: View {

    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    let showSpaceMarkers: Bool
    let onSelect: (Int) -> Void

    // 編集 sheet 用（index で持つのが安全：item を値で渡すと更新反映が面倒になる）
    @State private var editingIndex: Int? = nil
    @State private var isShowingEditor: Bool = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) { // ✅ Card の間隔（macOS らしい）
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]

                    RenamePreviewRowView(
                        item: item,
                        showSpaceMarkers: showSpaceMarkers,
                        onEdit: {
                            editingIndex = index
                            isShowingEditor = true
                        }
                    )
                    // 行タップで選択（編集ボタンとは別）
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedIndex = index
                        onSelect(index)
                    }
                    // 選択ハイライト（Card の外側に薄く）
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(
                                selectedIndex == index
                                ? Color.accentColor.opacity(0.55)
                                : Color.clear,
                                lineWidth: 1.5
                            )
                    )
                    .padding(.horizontal, 8) // Card を左右に少し浮かせる
                }
            }
            .padding(.vertical, 10)
        }
        .sheet(isPresented: $isShowingEditor) {
            if let index = editingIndex, items.indices.contains(index) {
                RenameDetailView(
                    original: items[index].original,
                    suggested: items[index].normalized,
                    editedText: bindingEditedText(for: index),
                    showSpaceMarkers: showSpaceMarkers,
                    onResetToSuggested: {
                        // 「提案に戻す」＝編集値をクリア（表示は suggested に戻る運用）
                        items[index].edited = ""
                    },
                    onClose: {
                        isShowingEditor = false
                    }
                )
                .frame(minWidth: 520, minHeight: 420)
            } else {
                // 念のため（index が消えた等）
                Text("編集対象が見つかりませんでした")
                    .padding()
            }
        }
    }

    // MARK: - Helpers

    /// items[index].edited への Binding を返す
    /// （RenameDetailView 側は @Binding var editedText: String を受け取る想定）
    private func bindingEditedText(for index: Int) -> Binding<String> {
        Binding<String>(
            get: { items[index].edited },
            set: { newValue in
                items[index].edited = newValue
            }
        )
    }
}
