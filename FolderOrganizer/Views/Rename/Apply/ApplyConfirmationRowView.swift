// Views/Rename/Apply/ApplyConfirmationRowView.swift

import SwiftUI

/// Apply 確認用の 1 行表示
struct ApplyConfirmationRowView: View {

    let plan: RenamePlan

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Diff
            let tokens = DiffBuilder.build(
                original: plan.originalName,
                modified: plan.targetName
            )

            DiffTextView(
                tokens: tokens,
                font: .system(
                    size: 14,
                    weight: .semibold,
                    design: .monospaced
                )
            )

            // Warnings
            if !plan.warnings.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)

                    Text("\(plan.warnings.count) 件の警告")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .cardStyle()
    }
}
