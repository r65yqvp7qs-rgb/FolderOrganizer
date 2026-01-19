// FolderOrganizer/Views/Rename/Preview/RenamePreviewView.swift
//
// プレビュー画面ラッパー（STEP D-3 対応）
// - 一覧表示は RenamePreviewList に委譲
// - 編集開始要求（ダブルクリック等）を上位へ伝えるだけ
//

import SwiftUI

struct RenamePreviewView: View {

    // MARK: - Inputs

    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    let onEditRequest: (Int) -> Void

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            // ヘッダー（必要最低限）
            HStack {
                Spacer()

                Text("\(items.count) 件のリネーム候補")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(14)

            // 一覧本体
            RenamePreviewList(
                items: $items,
                selectedIndex: $selectedIndex,
                onSelect: { index in
                    selectedIndex = index
                },
                onEditRequest: onEditRequest
            )
        }
    }
}
