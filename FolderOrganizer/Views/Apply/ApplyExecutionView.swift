// FolderOrganizer/Views/Apply/ApplyExecutionView.swift
//
// RenamePlan を実ファイルへ適用する実行ビュー。
// - v0.2 主目的：Apply 完了時に RenameSessionLog を自動保存（JSON Export）する
// - このブランチでは Undo 実行 UI / Service は未導入なので、RollbackInfo は表示のみ
// - 保存失敗は UX に影響させない（補助ログ）
//

import SwiftUI

struct ApplyExecutionView: View {

    // MARK: - Inputs

    let rootURL: URL
    let plans: [RenamePlan]
    let applyService: RenameApplyService
    let onClose: () -> Void

    // MARK: - State

    @State private var isExecuting: Bool = false
    @State private var results: [ApplyResult] = []
    @State private var rollbackInfo: RollbackInfo?

    // MARK: - AutoSave

    private let autoSaveService: RenameSessionLogAutoSaveService =
        DefaultRenameSessionLogAutoSaveService()

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Apply 実行")
                .font(.headline)

            if isExecuting {
                ProgressView("ファイルをリネーム中…")
            } else {
                ApplyResultList(
                    results: results,
                    rollbackInfo: rollbackInfo
                )
            }

            HStack {
                Spacer()

                Button("閉じる") {
                    onClose()
                }
            }
        }
        .padding()
        .onAppear {
            executeApplyIfNeeded()
        }
    }

    // MARK: - Apply

    private func executeApplyIfNeeded() {
        guard !isExecuting else { return }

        isExecuting = true

        // ✅ 現行 RenameApplyService の completion は (results, rollbackInfo)
        applyService.apply(plans: plans) { results, rollbackInfo in
            self.results = results
            self.rollbackInfo = rollbackInfo
            self.isExecuting = false

            // ✅ v0.2 の主目的：Apply 完了時に 1 回だけ自動保存
            autoSaveService.autoSaveAppliedSnapshot(
                rootURL: rootURL,
                plans: plans,
                results: results,
                rollbackInfo: rollbackInfo
            )
        }
    }
}
