//
// Views/Rename/Apply/ApplyExecutionView.swift
//
import SwiftUI

struct ApplyExecutionView: View {

    // MARK: - Dependencies

    let plans: [RenamePlan]
    let applyService: RenameApplyService

    let onFinish: ([ApplyResult]) -> Void
    let onCancel: () -> Void

    // MARK: - State

    @State private var progress: Double = 0
    @State private var currentIndex: Int = 0
    @State private var isCancelled: Bool = false
    @State private var isFinished: Bool = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 24) {

            Text("リネームを実行中…")
                .font(.title2)
                .bold()

            ProgressView(
                value: progress,
                total: Double(plans.count)
            )
            .frame(maxWidth: 360)

            Text(progressText)
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()

            HStack {
                Spacer()
                Button("キャンセル") {
                    isCancelled = true
                    onCancel()
                }
                .disabled(isFinished)
            }
        }
        .padding(32)
        .frame(minWidth: 420, minHeight: 260)
        .task {
            await execute()
        }
    }

    // MARK: - Progress text

    private var progressText: String {
        isFinished
        ? "完了"
        : "\(currentIndex) / \(plans.count)"
    }

    // MARK: - Execution

    private func execute() async {
        var results: [ApplyResult] = []

        for (index, plan) in plans.enumerated() {

            if isCancelled { break }

            // ✅ try / catch 不要
            let result = applyService.apply(plan)
            results.append(result)

            currentIndex = index + 1
            progress = Double(currentIndex)

            try? await Task.sleep(nanoseconds: 80_000_000)
        }

        isFinished = true
        onFinish(results)
    }
}
