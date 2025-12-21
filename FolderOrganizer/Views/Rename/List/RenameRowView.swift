//
// Views/RenameRowView.swift
//
import SwiftUI

struct RenameRowView: View {

    let item: RenameItem
    let showSpaceMarkers: Bool
    let onEdit: () -> Void

    /// 行内で統一するフォント
    private let baseFont: Font = .system(
        size: 13,
        weight: .regular,
        design: .monospaced
    )

    var body: some View {
        HStack(spacing: 12) {

            VStack(alignment: .leading, spacing: 4) {

                // 旧
                SpaceMarkerTextView(
                    item.original,
                    showSpaceMarkers: showSpaceMarkers,
                    font: baseFont
                )
                .opacity(0.6)

                // 新
                SpaceMarkerTextView(
                    item.displayNameForList,
                    showSpaceMarkers: showSpaceMarkers,
                    font: baseFont
                )
                .opacity(0.9)
            }

            Spacer()

            Button("編集") { onEdit() }
        }
        .padding(.vertical, 8)
    }
}
