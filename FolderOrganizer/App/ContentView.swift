//
//  App/ContentView.swift
//
//  メイン画面。
//  フォルダ選択 → スキャン → RenamePlan 生成 → Preview 表示
//

import SwiftUI
import AppKit

struct ContentView: View {

    // MARK: - State

    @State private var selectedFolderURL: URL?
    @State private var plans: [RenamePlan] = []
    @State private var errorMessage: String?
    @State private var selectionIndex: Int? = nil

    /// STEP 3-3: スペース可視化
    @State private var showSpaceMarkers: Bool = false

    // MARK: - Services

    private let scanService = FileScanService()
    private let planEngine = RenamePlanEngine()

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Header
            HStack {
                Button("フォルダを選択") {
                    selectFolder()
                }

                if let folderURL = selectedFolderURL {
                    Text(folderURL.path)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()
            }

            // View Option
            Toggle("スペースを可視化", isOn: $showSpaceMarkers)
                .toggleStyle(.checkbox)
                .font(.caption)

            Divider()

            // Error
            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            // Preview
            if plans.isEmpty {
                Text("フォルダを選択すると、リネームプレビューが表示されます。")
                    .foregroundStyle(.secondary)
            } else {
                RenamePreviewList(
                    plans: plans,
                    selectionIndex: $selectionIndex,
                    showSpaceMarkers: showSpaceMarkers,
                    onCommit: { index, newName in
                        plans[index].normalizedName = newName
                    }
                )
            }

            Spacer()
        }
        .padding()
        .frame(minWidth: 700, minHeight: 500)
    }

    // MARK: - Actions

    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false

        guard panel.runModal() == .OK,
              let url = panel.url else {
            return
        }

        selectedFolderURL = url
        loadFolder(url)
    }

    private func loadFolder(_ url: URL) {
        errorMessage = nil
        plans.removeAll()
        selectionIndex = nil

        let result = scanService.scan(rootURL: url)

        if !result.errors.isEmpty {
            errorMessage = "\(result.errors.count) 件のエラーが発生しました"
        }

        plans = result.urls.map {
            planEngine.generatePlan(for: $0)
        }
    }
}
