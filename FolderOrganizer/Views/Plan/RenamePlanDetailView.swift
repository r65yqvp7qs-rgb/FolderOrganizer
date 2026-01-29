// Views/Plan/RenamePlanDetailView.swift
//
// RenamePlan 詳細表示
//

import SwiftUI

struct RenamePlanDetailView: View {

    let plan: RenamePlan

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            LabeledContent("Target Parent Path") {
                Text(plan.targetParentURL.path)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textSelection(.enabled)
            }

            Divider()

            Section("Item") {
                VStack(alignment: .leading, spacing: 8) {

                    LabeledContent("original") {
                        Text(plan.item.original)
                            .font(.system(size: 13, design: .monospaced))
                            .textSelection(.enabled)
                    }

                    LabeledContent("finalName") {
                        Text(plan.item.finalName)
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .textSelection(.enabled)
                    }
                }
            }

            if !plan.item.issues.isEmpty {
                Divider()

                Section("Issues") {
                    ForEach(
                        Array(plan.item.issues).sorted(by: { $0.rawValue < $1.rawValue }),
                        id: \.self
                    ) { issue in
                        Text(issue.rawValue)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding()
    }
}
