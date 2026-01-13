// Views/Apply/ApplyResultView.swift
//
// Apply 実行後の結果表示画面
// ・成功 / skipped / 失敗の件数サマリを表示
// ・変更対象なし（全 skipped / 空）の場合は専用メッセージを表示
// ・個別結果を一覧表示
// ・Undo が可能な場合のみ Undo ボタンを表示
//

import SwiftUI

struct ApplyResultView: View {

    let results: [ApplyResult]
    let rollbackInfo: RollbackInfo?
    let onUndo: (RollbackInfo) -> Void
    let onClose: () -> Void

    // MARK: - Derived Counts

    private var successCount: Int {
        results.filter { $0.isSuccess }.count
    }

    private var skippedCount: Int {
        results.filter { $0.isSkipped }.count
    }

    private var failureCount: Int {
        results.filter { $0.error != nil }.count
    }

    // MARK: - State Flags

    /// Apply 対象が 0 件
    private var isEmptyResult: Bool {
        results.isEmpty
    }

    /// 全件 skipped（＝変更対象なし）
    private var isAllSkipped: Bool {
        !results.isEmpty &&
        successCount == 0 &&
        failureCount == 0 &&
        skippedCount > 0
    }

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Apply 結果")
                .font(.headline)

            // ===== 結果サマリ or メッセージ =====

            if isEmptyResult {
                Text("Apply 対象がありませんでした。")
                    .font(.caption)
                    .foregroundStyle(.secondary)

            } else if isAllSkipped {
                Text("変更対象はありませんでした。")
                    .font(.caption)
                    .foregroundStyle(.secondary)

            } else {
                Text(
                    "成功: \(successCount) 件 / " +
                    "スキップ: \(skippedCount) 件 / " +
                    "失敗: \(failureCount) 件"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Divider()

            // ===== 詳細一覧 =====

            if !results.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(results.indices, id: \.self) { index in
                            ApplyResultRowView(
                                result: results[index],
                                index: index
                            )
                        }
                    }
                }
            } else {
                Spacer()
            }

            Divider()

            // ===== Footer =====

            HStack {
                if let rollbackInfo {
                    Button("Undo") {
                        onUndo(rollbackInfo)
                    }
                }

                Spacer()

                Button("閉じる") {
                    onClose()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(16)
        .frame(minWidth: 420)
    }
}
