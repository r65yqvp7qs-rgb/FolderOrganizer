import SwiftUI

struct ContentView: View {

    @State private var items: [RenameItem] = []
    @State private var showingDetail = false
    @State private var detailIndex = 0

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Text("Folder Organizer")
                    .font(.system(size: 28, weight: .bold))

                Button("フォルダ名を読み込んで変換プレビュー") {
                    // いまはサンプルデータを読み込む
                    items = FileScanService.loadSampleNames()
                }
                .buttonStyle(.borderedProminent)

                Divider()
                    .padding(.vertical, 8)

                if items.isEmpty {
                    Text("上のボタンを押すとサンプルが読み込まれます。")
                        .foregroundColor(.secondary)
                        .padding(.top, 40)
                } else {
                    RenamePreviewList(items: $items)
                }
            }
            .padding()
            .background(AppTheme.colors.background)

            // 詳細オーバーレイ
            if showingDetail, detailIndex < items.count {
                RenameDetailView(
                    item: $items[detailIndex],
                    index: detailIndex,
                    total: items.count,
                    onPrev: movePrev,
                    onNext: moveNext,
                    onClose: { showingDetail = false }
                )
                .frame(width: 800, height: 520)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 16)
                .padding()
                .zIndex(10)
            }
        }
        .frame(minWidth: 900, minHeight: 600)
        .onAppear {
            // 起動時にもサンプル読み込み
            items = FileScanService.loadSampleNames()
        }
        .onReceive(NotificationCenter.default.publisher(for: .openDetailView)) { notif in
            if let idx = notif.object as? Int,
               idx >= 0, idx < items.count {
                detailIndex = idx
                showingDetail = true
            }
        }
    }

    private func movePrev() {
        guard !items.isEmpty else { return }
        if detailIndex > 0 { detailIndex -= 1 }
    }

    private func moveNext() {
        guard !items.isEmpty else { return }
        if detailIndex < items.count - 1 { detailIndex += 1 }
    }
}
