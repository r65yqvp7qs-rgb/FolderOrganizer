//
// Views/Rename/Preview/PreviewListContentView.swift
// Preview 一覧の中身（表示専用）
// STEP C: 編集状態への遷移のみ担当
//

import SwiftUI

struct PreviewListContentView: View {

    @ObservedObject var session: RenameSession
    let showSpaceMarkers: Bool

    var body: some View {
        List(selection: $session.selectedID) {
            previewRows
        }
        .listStyle(.plain)
    }

    // MARK: - Row Builder
    @ViewBuilder
    private var previewRows: some View {
        ForEach(session.items) { item in
            RenamePreviewRowView(
                item: item,
                onEdit: {
                    session.selectedID = item.id
                    session.isEditing = true
                }
            )
            .tag(item.id)
            .id(item.id)
            .listRowBackground(rowBackground(for: item))
        }
    }

    // MARK: - Background 判定
    private func rowBackground(for item: RenameItem) -> Color {
        session.selectedID == item.id
        ? Color.accentColor.opacity(0.15)
        : Color.clear
    }
}
