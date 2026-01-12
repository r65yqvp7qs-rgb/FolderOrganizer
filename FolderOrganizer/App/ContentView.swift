// App/ContentView.swift
//
// メイン画面
//

import SwiftUI
import AppKit

struct ContentView: View {

    // MARK: - State

    @State private var selectedFolderURL: URL?
    @State private var plans: [RenamePlan] = []
    @State private var selectionIndex: Int? = nil
    @State private var showSpaceMarkers: Bool = false

    // MARK: - Services

    private let scanService = FileScanService()
    private let planEngine = RenamePlanEngine()

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

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

            Toggle("スペース可視化", isOn: $showSpaceMarkers)

            RenamePreviewList(
                plans: plans,
                selectionIndex: $selectionIndex,
                showSpaceMarkers: showSpaceMarkers,
                onCommit: handleCommit
            )

            Spacer()
        }
        .padding()
    }

    // MARK: - Actions

    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false

        guard panel.runModal() == .OK, let folderURL = panel.url else {
            return
        }

        selectedFolderURL = folderURL
        rebuildPlans(for: folderURL)
    }

    private func rebuildPlans(for folderURL: URL) {
        let result = scanService.scan(rootURL: folderURL)
        plans = planEngine.generatePlans(
            urls: result.urls,
            targetParentURL: folderURL
        )
    }

    /// RenamePreviewList からの確定編集
    private func handleCommit(index: Int, newName: String) {
        let oldPlan = plans[index]
        let oldItem = oldPlan.item

        let newItem = RenameItem(
            original: oldItem.original,
            normalized: newName,
            source: .manual,
            issues: oldItem.issues
        )

        let newPlan = RenamePlan(
            originalURL: oldPlan.originalURL,
            targetParentURL: oldPlan.targetParentURL,
            item: newItem
        )

        plans[index] = newPlan
    }
}
