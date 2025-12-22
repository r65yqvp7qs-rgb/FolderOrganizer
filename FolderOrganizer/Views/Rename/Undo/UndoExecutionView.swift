//
// Views/Rename/Undo/UndoExecutionView.swift
// Undo 実行中ビュー
//
import SwiftUI

struct UndoExecutionView: View {

    // MARK: - Inputs

    /// Undo 対象の Apply 結果
    let applyResults: [ApplyResult]

    /// Undo サービス
    let undoService: DefaultRenameUndoService

    /// 完了時コールバック
    let onFinish: ([UndoResult]) -> Void

    /// キャンセル
    let onCancel: () -> Void


    // MARK: - State

    @State private var results: [UndoResult] = []
    @State private var currentIndex: Int = 0
    @State private var isCancelled: Bool = false
    @State private var isFinished: Bool = false


    // MARK: - Derived

    private var progress: Double {
        guard !applyResults.isEmpty else { return 1.0 }
        return Double(currentIndex) / Double(applyResults.count)
    }

    private var progressText: String {
        isFinished
        ? "完了"
        : "\(currentIndex) / \(applyResults.count)"
    }


    // MARK: - View

    var body: some View {
        VStack(spacing: 16) {

            Text("Undo Execution")
                .font(.title2)
                .bold()

            ProgressView(value: progress)
                .progressViewStyle(.linear)

            Text(progressText)
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Divider()

            HStack {
                Spacer()

                if !isFinished {
                    Button("キャンセル") {
                        isCancelled = true
                        onCancel()
                    }
                }
            }
        }
        .padding(20)
        .frame(minWidth: 420, minHeight: 200)
        .task {
            await executeUndo()
        }
    }


    // MARK: - Execution

    private func executeUndo() async {
        results.removeAll()
        currentIndex = 0

        for (index, applyResult) in applyResults.enumerated() {

            if isCancelled { break }

            // 成功した Apply のみ Undo
            guard applyResult.success else {
                currentIndex = index + 1
                continue
            }

            let undoResult = undoService.undo(applyResult)
            results.append(undoResult)

            currentIndex = index + 1

            // UI 更新を安定させるための微ディレイ
            try? await Task.sleep(nanoseconds: 80_000_000)
        }

        isFinished = true
        onFinish(results)
    }
}
