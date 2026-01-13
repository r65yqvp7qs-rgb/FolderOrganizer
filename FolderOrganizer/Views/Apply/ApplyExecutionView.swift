// Views/Apply/ApplyExecutionView.swift
//
// Apply を実行中の進捗表示画面
// ・RenamePlan を受け取り、RenameApplyService を実行
// ・完了後、ApplyResult 配列を onFinish で返す
// ・この View 自身は結果を解釈しない（責務分離）
//

import SwiftUI

struct ApplyExecutionView: View {

    // MARK: - Inputs

    /// 適用対象の RenamePlan 一覧
    let plans: [RenamePlan]

    /// Apply 実行 Service
    let applyService: RenameApplyService

    /// 完了時コールバック
    let onFinish: ([ApplyResult]) -> Void

    // MARK: - State

    @State private var isRunning: Bool = false

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Apply 実行中")
                .font(.headline)

            ProgressView()
                .progressViewStyle(.linear)

            Text("件数: \(plans.count)")
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(24)
        .onAppear {
            run()
        }
    }

    // MARK: - Execute

    private func run() {
        guard !isRunning else { return }
        isRunning = true

        applyService.apply(plans: plans) { results in
            DispatchQueue.main.async {
                onFinish(results)
            }
        }
    }
}
