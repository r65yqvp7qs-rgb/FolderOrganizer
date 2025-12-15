// Views/RenamePlanDetailView.swift
import SwiftUI

struct RenamePlanDetailView: View {

    let plan: RenamePlan

    var body: some View {
        Form {

            // MARK: - Rename
            Section("Rename") {

                LabeledContent("Before") {
                    Text(plan.originalName)
                }

                LabeledContent("After") {
                    DiffBuilder.highlightDiff(
                        old: plan.originalName,
                        new: plan.targetName
                    )
                    .fontWeight(.semibold)
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
                        // warning が message を持つ想定（持ってない場合は RenameWarning 側で合わせる）
                        Text(warning.message)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .navigationTitle("Rename Preview")
    }
}
