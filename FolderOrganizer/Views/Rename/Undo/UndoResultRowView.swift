//
// Views/Rename/Undo/UndoResultRowView.swift
// Undo 結果 1 行表示
//
import SwiftUI

struct UndoResultRowView: View {

    let result: UndoResult

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            HStack(spacing: 8) {
                Image(systemName: result.success
                      ? "arrow.uturn.backward.circle.fill"
                      : "xmark.octagon.fill")
                    .foregroundColor(result.success ? .green : .orange)

                // 元の名前（ApplyResult 経由）
                Text(result.applyResult.plan.originalName)
                    .font(
                        .system(
                            size: 13,
                            weight: .semibold,
                            design: .monospaced
                        )
                    )
            }

            // エラー表示
            if let error = result.error {
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
    }
}
