//
// App/ContentView.swift
// アプリ全体のエントリポイント（RenameSession を保持）
//

import SwiftUI

struct ContentView: View {

    // ★ここが最重要：状態は session に集約し、一覧も編集も同じ session を見る
    @StateObject private var session = RenameSession(items: [
        RenameItem(original: "[作者] 作品A", normalized: "作品A", flagged: false),
        RenameItem(original: "[作者] 作品B", normalized: "作品B", flagged: false),
        RenameItem(original: "[作者] 作品C", normalized: "作品C", flagged: false),
    ])

    @State private var showSpaceMarkers: Bool = true

    var body: some View {
        VStack(spacing: 16) {

            Toggle("スペース可視化", isOn: $showSpaceMarkers)
                .toggleStyle(.checkbox)
                .padding(.top, 24)
                .padding(.bottom, 12)

            RenamePreviewListView(
                session: session,
                showSpaceMarkers: showSpaceMarkers
            )

            Spacer()
        }
        .padding(24)
        .background(Color(nsColor: .windowBackgroundColor))
        .ignoresSafeArea()

        // 編集シート（一覧と同じ session を渡す）
        .sheet(isPresented: $session.isEditing) {
            RenameEditView(
                session: session,
                showSpaceMarkers: showSpaceMarkers
            )
        }
    }
}
