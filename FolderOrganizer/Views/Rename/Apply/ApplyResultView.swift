//
// Views/Rename/Apply/ApplyResultView.swift
// Apply 実行結果表示ビュー（共通 Row 使用）
//
import SwiftUI

struct ApplyResultView: View {

    // MARK: - Inputs

    let results: [ApplyResult]

    /// Undo を開始する（成功分のみ渡す）
    let onUndo: ([ApplyResult]) -> Void

    /// 完了して閉じる
    let onClose: () -> Void


    // MARK: - Derived

    private var successResults: [ApplyResult] {
        results.filter { $0.success }
    }

    private var failureResults: [ApplyResult] {
        results.filter { !$0.success }
    }


    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Apply Result")
                .font(.title2)
                .bold()

            // サマリー
            HStack(spacing: 16) {
                summaryItem(
                    title: "成功",
                    count: successResults.count,
                    color: .green
                )
                summaryItem(
                    title: "失敗",
                    count: failureResults.count,
                    color: .orange
                )
            }

            Divider()

            // 成功一覧
            if !successResults.isEmpty {
                Section {
                    resultList(successResults)
                } header: {
                    Text("適用された項目")
                        .font(.headline)
                }
            }

            // 失敗一覧
            if !failureResults.isEmpty {
                Section {
                    resultList(failureResults)
                } header: {
                    Text("失敗した項目")
                        .font(.headline)
                }
            }

            Spacer()

            Divider()

            HStack {
                Button("Undo") {
                    onUndo(successResults)
                }
                .disabled(successResults.isEmpty)

                Spacer()

                Button("閉じる") {
                    onClose()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(minWidth: 520, minHeight: 360)
    }


    // MARK: - Components

    private func summaryItem(
        title: String,
        count: Int,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text("\(count)")
                .font(.title3)
                .bold()
                .foregroundColor(color)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
    }

    private func resultList(_ items: [ApplyResult]) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(items) { result in
                    ExecutionResultRowView(
                        success: result.success,
                        title: result.plan.targetName,
                        errorMessage: result.error?.localizedDescription
                    )
                }
            }
            .padding(.vertical, 4)
        }
    }
}
