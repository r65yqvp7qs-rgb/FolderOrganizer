import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]

                    RenamePreviewRow(
                        original: item.original,
                        normalized: item.normalized,
                        isOdd: index % 2 == 0,
                        flagged: $items[index].flagged
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        openDetail(index)
                    }
                }
            }
            .frame(maxWidth: 900)          // 一覧の固定幅
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .background(AppTheme.colors.background)
    }

    private func openDetail(_ index: Int) {
        NotificationCenter.default.post(
            name: .openDetailView,
            object: index
        )
    }
}
