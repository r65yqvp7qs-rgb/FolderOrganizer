// App/ContentView.swift

import SwiftUI

struct ContentView: View {

    @State private var items: [RenameItem] = []
    @State private var selectedIndex: Int? = nil
    @State private var showSpaceMarkers: Bool = true

    var body: some View {
        VStack(spacing: 16) {

            Toggle("スペース可視化", isOn: $showSpaceMarkers)
                .toggleStyle(.checkbox)
                .padding(.top, 24)
                .padding(.bottom, 12)

            RenamePreviewListView(
                items: $items,
                showSpaceMarkers: showSpaceMarkers,
                onSelect: { index in
                    selectedIndex = index
                }
            )

            Spacer()
        }
        .padding(24)
        .background(Color(nsColor: .windowBackgroundColor))
        .ignoresSafeArea()
        .onAppear {
            loadDummy()
        }
    }

    // 仮データ読み込み
    private func loadDummy() {
        items = [
            RenameItem(
                original: "[作者] 作品A",
                normalized: "作品A",
                flagged: false
            ),
            RenameItem(
                original: "[作者] 作品B",
                normalized: "作品B",
                flagged: false
            ),
            RenameItem(
                original: "[作者] 作品C",
                normalized: "作品C",
                flagged: false
            )
        ]
    }
}
