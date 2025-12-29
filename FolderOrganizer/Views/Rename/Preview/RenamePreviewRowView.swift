// Views/Rename/Preview/RenamePreviewRowView.swift
import SwiftUI

/// 一覧の 1 行表示（STEP C 用）
struct RenamePreviewRowView: View {

    let item: RenameItem
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            // フラグ表示
            if item.flagged {
                Image(systemName: "flag.fill")
                    .foregroundColor(.orange)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.original)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)

                Text(item.normalized)
                    .font(.system(size: 13, weight: .regular, design: .monospaced))
            }

            Spacer()

            Button("編集") {
                onEdit()
            }
            .buttonStyle(.bordered)
        }
        .padding(.vertical, 4)
    }
}
