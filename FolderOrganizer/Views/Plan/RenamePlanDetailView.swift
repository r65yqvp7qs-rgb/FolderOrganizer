// Views/Plan/RenamePlanDetailView.swift

import SwiftUI

struct RenamePlanDetailView: View {

    let plan: RenamePlan

    var body: some View {
        Form {

            // MARK: - Rename
            Section("Rename") {
                renameSection
            }

            // MARK: - Detected Information
            Section("Detected Information") {
                LabeledContent("Author") {
                    Text(plan.detectedAuthor ?? "—")
                }
            }

            // MARK: - Warnings
            if !plan.warnings.isEmpty {
                Section("Warnings") {
                    ForEach(plan.warnings, id: \.self) { warning in
                        Text(warning.message)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
    }

    // MARK: - Rename Section（ViewBuilder外でロジック処理）
    private var renameSection: some View {

        let tokens = DiffBuilder.build(
            original: plan.originalName,
            modified: plan.targetName
        )

        return VStack(alignment: .leading, spacing: 8) {

            LabeledContent("Before") {
                Text(plan.originalName)
                    .font(.system(size: 13, design: .monospaced))
            }

            LabeledContent("After") {
                DiffTextView(
                    tokens: tokens,
                    font: .system(
                        size: 13,
                        weight: .semibold,
                        design: .monospaced
                    )
                )
            }
        }
        .padding(.vertical, 4)
    }
}
