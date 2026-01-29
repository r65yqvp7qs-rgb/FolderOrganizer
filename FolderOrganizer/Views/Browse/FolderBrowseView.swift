// FolderOrganizer/FolderOrganizer/Views/Browse/FolderBrowseView.swift
//
// フォルダツリー表示 View
// - 役割（SERIES / VOLUME / UNKNOWN）
// - 確信度（★）
// - D-3: UNKNOWN の場合は推定理由も補助表示（FolderRowView 側）
//

import SwiftUI

struct FolderBrowseView: View {

    let rootNode: FolderNode?

    var body: some View {
        Group {
            if let root = rootNode {
                List {
                    OutlineGroup([root], children: \.children) { node in
                        FolderRowView(node: node)
                    }
                }
            } else {
                Text("フォルダが選択されていません")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
