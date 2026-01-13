//
//  Views/Rename/Undo/UndoExecutionView.swift
//  FolderOrganizer
//
//  Undo を実行し、結果を表示する View
//

import SwiftUI

struct UndoExecutionView: View {

    let rollback: RollbackInfo
    let undoService: RenameUndoService
    let onClose: () -> Void

    @State private var isExecuting: Bool = false
    @State private var results: [UndoResult] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Undo 実行")
                .font(.headline)

            if isExecuting {
                ProgressView("Undo を実行中…")
            } else {
                UndoResultView(
                    undoResults: results,
                    rollbackInfo: rollback,
                    onClose: onClose
                )
            }

            Divider()

            HStack {
                Spacer()
                Button("閉じる") {
                    onClose()
                }
            }
        }
        .padding(24)
        .frame(minWidth: 520, minHeight: 420)
        .onAppear {
            executeUndo()
        }
    }

    // MARK: - Private

    private func executeUndo() {
        guard !isExecuting else { return }

        isExecuting = true
        results = []

        DispatchQueue.global(qos: .userInitiated).async {
            let undoResults = undoService.undo(rollback)

            DispatchQueue.main.async {
                self.results = undoResults
                self.isExecuting = false
            }
        }
    }
}
