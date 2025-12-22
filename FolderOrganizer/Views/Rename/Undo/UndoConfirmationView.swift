//
// Views/Rename/Undo/UndoConfirmationView.swift
// Undo 実行前の最終確認ビュー
//
import SwiftUI

/// Undo 実行前の確認ダイアログ
/// - ApplyExecution の結果（ApplyResult）を受け取り
/// - 「本当に元に戻すか」を確認する
struct UndoConfirmationView: View {

    // MARK: - Inputs

    /// Undo 対象となる Apply 結果一覧
    let applyResults: [ApplyResult]

    /// Undo を実行する
    let onConfirm: () -> Void

    /// キャンセルして戻る
    let onCancel: () -> Void


    // MARK: - Derived

    /// Undo 対象の件数（成功した Apply のみ）
    private var undoTargetCount: Int {
        applyResults.filter { $0.success }.count
    }


    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // タイトル
            Text("Undo Confirmation")
                .font(.title2)
                .bold()

            Divider()

            // 説明文
            VStack(alignment: .leading, spacing: 8) {
                Text("以下の変更を元に戻します。")
                    .font(.body)

                Text("対象件数: \(undoTargetCount) 件")
                    .font(.headline)
            }

            // 注意喚起
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)

                Text("この操作はファイルを元の場所・名前に戻します。")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Divider()

            // ボタン群
            HStack {
                Spacer()

                Button("キャンセル") {
                    onCancel()
                }

                Button("元に戻す") {
                    onConfirm()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(minWidth: 420, minHeight: 220)
    }
}
