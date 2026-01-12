// App/ContentView.swift
//
// メイン画面
// - フォルダ選択 → URL スキャン → RenamePlan 生成 → プレビュー
// - Apply / Undo の FlowState 制御
//

import SwiftUI
import AppKit

struct ContentView: View {

    // MARK: - Flow

    @State private var flowState: RenameFlowState = .preview

    // MARK: - Data

    @State private var plans: [RenamePlan] = []
    @State private var applyResults: [ApplyResult] = []
    @State private var undoResults: [UndoResult] = []
    @State private var rollbackInfo: RollbackInfo? = nil

    // MARK: - Preview States

    @State private var selectionIndex: Int? = nil
    @State private var showSpaceMarkers: Bool = true

    // MARK: - Services

    private let scanService = FileScanService()

    // MARK: - View

    @ViewBuilder
    var body: some View {
        switch flowState {

        case .preview:
            VStack(spacing: 0) {

                HStack {
                    Button("フォルダを選択") {
                        selectFolder()
                    }

                    Spacer()

                    Text("\(plans.count) 件")
                        .foregroundStyle(.secondary)
                }
                .padding()

                Divider()

                RenamePreviewList(
                    plans: plans,
                    selectionIndex: $selectionIndex,
                    showSpaceMarkers: showSpaceMarkers,
                    onCommit: handleCommit
                )

                Divider()

                HStack {
                    Toggle("スペース可視化", isOn: $showSpaceMarkers)

                    Spacer()

                    Button("Apply") {
                        startApply()
                    }
                    .keyboardShortcut(.defaultAction)
                    .disabled(plans.isEmpty)
                }
                .padding()
            }

        case .applying:
            ProgressView("Applying...")

        case .applyResult(let results):
            ApplyResultView(
                results: results,
                rollbackInfo: rollbackInfo,
                onUndo: startUndo(rollbackInfo:),
                onClose: { flowState = .preview }
            )

        case .undoing:
            ProgressView("Undoing...")

        case .undoResult(let results):
            if let rollbackInfo {
                UndoResultView(
                    undoResults: results,
                    rollbackInfo: rollbackInfo,
                    onClose: { flowState = .preview }
                )
            } else {
                Text("Undo 情報がありません")
            }
        }
    }

    // MARK: - Folder Select

    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            loadPlans(from: url)
        }
    }

    private func loadPlans(from rootURL: URL) {
        let result = scanService.scan(rootURL: rootURL)

        plans = result.urls.map { url in
            let normalizeResult = NameNormalizer.normalize(url.lastPathComponent)

            let item = RenameItem(
                original: url.lastPathComponent,
                normalized: normalizeResult.normalized,
                source: .auto,
                issues: []
            )

            return RenamePlan(
                originalURL: url,
                targetParentURL: url.deletingLastPathComponent(),
                item: item
            )
        }

        selectionIndex = nil
    }

    // MARK: - Actions

    private func handleCommit(index: Int, newName: String) {
        guard plans.indices.contains(index) else { return }

        let oldPlan = plans[index]
        let oldItem = oldPlan.item

        let updatedItem = RenameItem(
            id: oldItem.id,
            original: oldItem.original,
            normalized: newName,
            source: oldItem.source,
            issues: oldItem.issues
        )

        plans[index] = RenamePlan(
            id: oldPlan.id,
            originalURL: oldPlan.originalURL,
            targetParentURL: oldPlan.targetParentURL,
            item: updatedItem
        )
    }

    private func startApply() {
        flowState = .applying
        flowState = .applyResult(results: applyResults)
    }

    private func startUndo(rollbackInfo: RollbackInfo) {
        flowState = .undoing
        flowState = .undoResult(results: undoResults)
    }
}
