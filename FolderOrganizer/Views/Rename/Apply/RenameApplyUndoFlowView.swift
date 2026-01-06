// Views/Rename/Apply/RenameApplyUndoFlowView.swift
//
// Apply 実行後の結果一覧と Undo 操作をまとめて扱う画面。
// ApplyResult は struct 前提（isSuccess / error / undoInfo）。
//

import SwiftUI

struct RenameApplyUndoFlowView: View {

    /// Apply 実行結果一覧
    let results: [ApplyResult]

    /// 閉じるアクション
    let onClose: () -> Void

    /// Undo 実行アクション
    let onUndo: ([ApplyResult]) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Header
            HStack {
                Text("Apply 結果")
                    .font(.headline)

                Spacer()

                Button("閉じる") {
                    onClose()
                }
            }

            Divider()

            // MARK: - Result List
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(results.enumerated()), id: \.offset) { index, result in
                        ApplyResultRowView(
                            result: result,
                            index: index
                        )
                    }
                }
                .padding(.vertical, 4)
            }

            Divider()

            // MARK: - Footer
            HStack {
                Text(summaryText)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button("Undo") {
                    onUndo(successResults)
                }
                .disabled(successResults.isEmpty)
            }
        }
        .padding()
        .frame(minWidth: 520, minHeight: 360)
    }

    // MARK: - Summary

    private var successResults: [ApplyResult] {
        results.filter { $0.isSuccess }
    }

    private var failureResults: [ApplyResult] {
        results.filter { !$0.isSuccess }
    }

    private var summaryText: String {
        let successCount = successResults.count
        let failureCount = failureResults.count

        if failureCount == 0 {
            return "\(successCount) 件すべて成功しました"
        } else {
            return "成功 \(successCount) 件 / 失敗 \(failureCount) 件"
        }
    }
}
