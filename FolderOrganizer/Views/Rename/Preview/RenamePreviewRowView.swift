// Views/Rename/Preview/RenamePreviewRowView.swift

import SwiftUI

struct RenamePreviewRowView: View {

    let item: RenameItem
    let showSpaceMarkers: Bool
    let onEdit: () -> Void

    /// 行内で統一する等幅フォント
    private let baseFont: Font = .system(
        size: 13,
        weight: .regular,
        design: .monospaced
    )

    var body: some View {
        HStack(spacing: 12) {

            VStack(alignment: .leading, spacing: 4) {

                // 旧名（薄く表示）
                SpaceMarkerTextView(
                    item.original,
                    showSpaceMarkers: showSpaceMarkers,
                    font: baseFont
                )
                .opacity(0.6)

                // 新名プレビュー
                SpaceMarkerTextView(
                    previewName,
                    showSpaceMarkers: showSpaceMarkers,
                    font: baseFont
                )
                .opacity(0.9)
            }

            Spacer()

            Button("編集") {
                onEdit()
            }
        }
        .padding(.vertical, 8)
    }

    /// Preview 用表示名
    private var previewName: String {
        item.edited.isEmpty ? item.normalized : item.edited
    }
}
