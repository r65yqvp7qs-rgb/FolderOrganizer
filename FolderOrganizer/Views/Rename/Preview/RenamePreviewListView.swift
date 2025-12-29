// Views/Rename/Preview/RenamePreviewListView.swift
import SwiftUI

/// 一覧 View（STEP C 最小）
struct RenamePreviewListView: View {

    @ObservedObject var session: RenameSession

    var body: some View {
        ZStack {
            List(selection: $session.selectedID) {
                ForEach(session.items) { item in
                    RenamePreviewRowView(
                        item: item,
                        onEdit: {
                            session.selectedID = item.id
                            session.startEditing()
                        }
                    )
                    .tag(item.id)
                }
            }
            .listStyle(.plain)
            .disabled(session.isEditing)

            // 編集中オーバーレイ（ダミー）
            if session.isEditing {
                RenameEditView(session: session)
            }
        }
        // Esc で編集終了
        .keyboardShortcut(.escape, modifiers: [])
        .onExitCommand {
            if session.isEditing {
                session.finishEditing()
            }
        }
    }
}
