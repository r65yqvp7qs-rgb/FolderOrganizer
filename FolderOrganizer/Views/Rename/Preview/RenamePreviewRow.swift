//
// Views/Rename/RenamePreviewRow.swift
//
import SwiftUI

struct RenamePreviewRow: View {

    let item: RenameItem
    let showSpaceMarkers: Bool
    let onEdit: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {

            VStack(alignment: .leading, spacing: 6) {

                // 元の名前（薄め）
                SpaceMarkerTextView(
                    item.original,
                    showSpaceMarkers: showSpaceMarkers,
                    font: .system(size: 12, design: .monospaced)
                )
                .opacity(0.65)

                // 新しい名前（主役）
                SpaceMarkerTextView(
                    item.displayNameForList,
                    showSpaceMarkers: showSpaceMarkers,
                    font: .system(size: 14, weight: .semibold, design: .monospaced)
                )
            }

            Spacer()

            Button("編集") {
                onEdit()
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        // ✅ Card 化
        .cardStyle()
    }
}
