//
// Views/Rename/Preview/RenamePreviewRowView.swift
// Preview 一覧の 1 行
//

import SwiftUI

struct RenamePreviewRowView: View {

    let item: RenameItem
    let showSpaceMarkers: Bool
    let onEdit: () -> Void

    var body: some View {
        HStack {
            Text(item.original)
                .opacity(0.6)

            Spacer()

            Button("編集") {
                onEdit()
            }
        }
        .padding(.vertical, 8)
    }
}
