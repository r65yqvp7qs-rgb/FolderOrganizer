// Views/Rename/Apply/UndoConfirmationView.swift
//
// Apply 後に Undo を実行する前の確認画面。
// RollbackInfo.Move を使って Undo 内容を表示する。
//

import SwiftUI

struct UndoConfirmationView: View {

    // MARK: - Input

    let results: [ApplyResult]
    let isExecuting: Bool
    let onExecute: () -> Void
    let onCancel: () -> Void

    // MARK: - Derived

    /// Undo 対象となる Move 一覧
    private var rollbackMoves: [RollbackInfo.Move] {
        results.compactMap { result in
            guard
                result.isSuccess,
                let undoInfo = result.undoInfo
            else {
                return nil
            }

            return RollbackInfo.Move(
                from: undoInfo.from,
                to: undoInfo.to
            )
        }
    }

    private var descriptionText: String {
        "以下のリネーム結果を元に戻します。"
    }

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Undo の確認")
                .font(.headline)

            Text(descriptionText)
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(rollbackMoves.enumerated()), id: \.offset) { index, move in
                        UndoResultRowView(
                            index: index,
                            move: move
                        )
                    }
                }
            }

            Divider()

            HStack {
                Button("キャンセル") {
                    onCancel()
                }

                Spacer()

                Button("Undo 実行") {
                    onExecute()
                }
                .disabled(isExecuting || rollbackMoves.isEmpty)
            }
        }
        .padding()
        .frame(minWidth: 520, minHeight: 360)
    }
}
