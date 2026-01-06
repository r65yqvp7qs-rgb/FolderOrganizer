// App/ContentView.swift
//
// FolderOrganizer
// Rename → Apply → Undo のフローを制御するメイン View
//

import SwiftUI

struct ContentView: View {

    // MARK: - State
    @State private var flowState: RenameFlowState = .preview
    @State private var plans: [RenamePlan] = []
    @State private var applyResults: [ApplyResult] = []

    // MARK: - Services
    private let applyService: RenameApplyService = DefaultRenameApplyService()
    private let undoService: RenameUndoService = DefaultRenameUndoService()

    // MARK: - View
    var body: some View {
        VStack {
            switch flowState {

            // MARK: Preview
            case .preview:
                Button("Apply") {
                    startApply()
                }

            // MARK: Applying
            case .applying:
                ProgressView("Apply 実行中…")

            // MARK: Applied
            case .applied(let results):
                RenameApplyUndoFlowView(
                    results: results,
                    onClose: {
                        flowState = .preview
                    },
                    onUndo: { results in
                        startUndo(results: results)
                    }
                )

            // MARK: Undoing
            case .undoing:
                ProgressView("Undo 実行中…")
            }
        }
        .padding()
        .frame(minWidth: 600, minHeight: 400)
    }

    // MARK: - Actions

    private func startApply() {
        flowState = .applying

        applyService.apply(plans: plans) { results in
            DispatchQueue.main.async {
                self.applyResults = results
                // ✅ ラベル必須
                self.flowState = .applied(results: results)
            }
        }
    }

    private func startUndo(results: [ApplyResult]) {
        flowState = .undoing

        let rollback = RollbackInfo(
            moves: results.compactMap { result in
                guard let undoInfo = result.undoInfo else { return nil }
                return RollbackInfo.Move(
                    from: undoInfo.from,
                    to: undoInfo.to
                )
            }
        )

        // ✅ completion は引数なし
        undoService.undo(rollback: rollback) { _ in
            DispatchQueue.main.async {
                self.flowState = .preview
            }
        }
    }
}
