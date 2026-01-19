// FolderOrganizer/Views/Rename/Preview/RenamePreviewRow.swift
//
// 一覧の1行（旧/新）
// - 旧/新の文字サイズは同じ
// - 変更があったら「目印」を付ける（左の点）
//

import SwiftUI

struct RenamePreviewRow: View {

    let original: String
    let normalized: String
    let isSelected: Bool
    let isChanged: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {

            Circle()
                .fill(isChanged ? Color.orange : Color.clear)
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            VStack(alignment: .leading, spacing: 4) {
                Text(original)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(normalized)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
            }
            .font(.system(size: 14)) // ✅ 旧/新 同じサイズ
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.blue.opacity(0.25) : Color(NSColor.windowBackgroundColor).opacity(0.25))
        )
    }
}
