//
// Views/Rename/Apply/ApplyResultView.swift
// Apply 実行結果表示ビュー
//
import SwiftUI

/// Apply 実行後の結果表示
/// - 成功 / 失敗を一覧で表示
/// - Undo への導線を提供する
struct ApplyResultView: View {

    // MARK: - Inputs

    let results: [ApplyResult]

    /// Undo を開始する
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

            // タイトル
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
                    resultList(successResults, success: true)
                } header: {
                    Text("成功した変更")
                        .font(.headline)
                }
            }

            // 失敗一覧
            if !failureResults.isEmpty {
                Section {
                    resultList(failureResults, success: false)
                } header: {
                    Text("失敗した変更")
                        .font(.headline)
                }
            }

            Spacer()

            Divider()

            // アクション
            HStack {
                Button("Undo") {
                    onUndo(successResults)
                }
                .disabled(successResults.isEmpty)

                Spacer()

                Button("完了") {
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

    private func resultList(
        _ items: [ApplyResult],
        success: Bool
    ) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(items) { result in
                    ApplyResultRowView(
                        result: result,
                        success: success
                    )
                }
            }
            .padding(.vertical, 4)
        }
    }
}
