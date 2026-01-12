//
//  RenamePlanDetailView.swift
//  FolderOrganizer
//
//  RenamePlan の詳細表示
//

import SwiftUI

struct RenamePlanDetailView: View {

    let plan: RenamePlan

    var body: some View {
        Form {

            // MARK: - Rename
            Section("Rename") {
                renameSection
            }

            // MARK: - Warnings（NormalizeResult 由来）
            if !plan.normalizeResult.warnings.isEmpty {
                Section("Warnings") {
                    ForEach(plan.normalizeResult.warnings.indices, id: \.self) { index in
                        Text(plan.normalizeResult.warnings[index])
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding()
    }

    // MARK: - Rename Section
    private var renameSection: some View {
        VStack(alignment: .leading, spacing: 8) {

            LabeledContent("Before") {
                Text(plan.originalURL.lastPathComponent)
                    .font(.system(size: 13, design: .monospaced))
            }

            LabeledContent("After") {
                Text(destinationName)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
            }
        }
        .padding(.vertical, 4)
    }

    private var destinationName: String {
        plan.destinationURL.lastPathComponent
    }
}
