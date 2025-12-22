//
// Views/Rename/Preview/PreviewRowView.swift
// 【新規】Preview 行表示（1行分）
//
import SwiftUI

struct PreviewRowView: View {

    let item: RenameItem
    let index: Int
    let isSelected: Bool

    let showSpaceMarkers: Bool
    @Binding var flagged: Bool

    let onSelect: () -> Void

    var body: some View {
        RenamePreviewRowView(
            item: item,
            showSpaceMarkers: showSpaceMarkers,
            onEdit: onSelect
        )
    }
}
