// FolderOrganizer/App/ContentView.swift
//
// ルート画面（Browse）
// - 「フォルダを選択」ボタンで NSOpenPanel を開く
// - 選択されたフォルダから FolderTreeBuilder でツリーを構築
// - FolderBrowseView に rootNode を渡して表示
//

import SwiftUI
import AppKit

struct ContentView: View {

    @State private var selectedFolderURL: URL?
    @State private var rootNode: FolderNode?
    @State private var errorMessage: String?

    private let treeBuilder = FolderTreeBuilder()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Header
            HStack(spacing: 12) {
                Button("フォルダを選択") {
                    selectFolder()
                }

                if let url = selectedFolderURL {
                    Text(url.path)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                } else {
                    Text("未選択")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            // Tree
            FolderBrowseView(rootNode: rootNode)
        }
        .padding()
        .frame(minWidth: 900, minHeight: 600)
    }

    // MARK: - Folder Picker

    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = "選択"

        if panel.runModal() == .OK, let url = panel.url {
            selectedFolderURL = url
            rebuildTree(for: url)
        }
    }

    private func rebuildTree(for url: URL) {
        do {
            errorMessage = nil
            rootNode = try treeBuilder.buildTree(from: url)
        } catch {
            rootNode = nil
            errorMessage = "ツリー構築に失敗しました: \(error.localizedDescription)"
        }
    }
}
