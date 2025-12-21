//
// Views/Plan/RenamePlanDetailView.swift
//
import SwiftUI

struct RenamePlanDetailView: View {

    let plan: RenamePlan

    var body: some View {
        Form {

            // MARK: - Rename
            Section("Rename") {

                LabeledContent("Before") {
                    Text(plan.originalName)
                        .font(.system(size: 13, design: .monospaced))
                }

                // ✅ 差分は ViewBuilder の外で生成
                let tokens = DiffBuilder.build(
                    old: plan.originalName,
                    new: plan.targetName
                )

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

            // MARK: - Detected Information
            Section("Detected Information") {
                LabeledContent("Author") {
                    Text(plan.detectedAuthor ?? "—")
                }
            }

            // MARK: - Warnings
            if !plan.warnings.isEmpty {
                Section("Warnings") {
                    ForEach(Array(plan.warnings.enumerated()), id: \.offset) { _, warning in
                        Text(warning.message)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .navigationTitle("Rename Preview")
    }
}
