//
// Views/Rename/Undo/UndoResultRowView.swift
// Undo 結果 1 行表示
//
import SwiftUI

struct UndoResultRowView: View {

    let result: UndoResult
    let success: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            HStack(spacing: 8) {
                Image(systemName: success ? "checkmark.circle.fill" : "xmark.octagon.fill")
                    .foregroundColor(success ? .green : .orange)

                Text(result.plan.originalName)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
            }

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
