//
// Views/Rename/Preview/RenamePreviewListView.swift
// Preview 一覧本体（Session を監視）
//

import SwiftUI

struct RenamePreviewListView: View {

    @ObservedObject var session: RenameSession
    let showSpaceMarkers: Bool

    var body: some View {
        ScrollViewReader { proxy in
            List(selection: $session.selectedID) {

                ForEach(session.items) { item in
                    RenamePreviewRowView(
                        item: item,
                        showSpaceMarkers: showSpaceMarkers,
                        onEdit: {
                            session.selectedID = item.id
                            session.isEditing = true
                        }
                    )
                    .tag(item.id)          // ← selection 用
                    .id(item.id)           // ← scrollTo 用
                    .listRowBackground(
                        session.selectedID == item.id
                        ? Color.accentColor.opacity(0.15)
                        : Color.clear
                    )
                }
            }
            // 選択変更時に自動スクロール
            .onChange(of: session.selectedID) { _, newID in
                guard let newID else { return }
                withAnimation {
                    proxy.scrollTo(newID, anchor: .center)
                }
            }
            // 編集画面
            .sheet(isPresented: $session.isEditing) {
                RenameEditView(
                    session: session,
                    showSpaceMarkers: showSpaceMarkers
                )
            }
        }
    }
}
