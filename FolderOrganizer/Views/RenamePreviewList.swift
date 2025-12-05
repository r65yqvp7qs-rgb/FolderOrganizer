//  Views/RenamePreviewList.swift

import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]

    @State private var selectedIndex: Int = 0

    // 個別要素の flagged だけをバインディングするヘルパー
    private func binding(for item: RenameItem) -> Binding<Bool> {
        Binding(
            get: {
                items.first(where: { $0.id == item.id })?.flagged ?? false
            },
            set: { newValue in
                if let index = items.firstIndex(where: { $0.id == item.id }) {
                    items[index].flagged = newValue
                }
            }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(items) { item in
                    RenamePreviewRow(
                        original: item.original,
                        normalized: item.normalized,
                        isOdd: item.id.hashValue % 2 == 0,
                        flagged: binding(for: item)
                    )
                }
            }
            // ウィンドウ幅ほぼいっぱい、左右に少し余白だけ
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.colors.background)
    }

    // 既存の詳細画面オープン通知（必要なら使用）
    func openDetail(_ index: Int) {
        NotificationCenter.default.post(
            name: .openDetailView,
            object: index
        )
    }
}
