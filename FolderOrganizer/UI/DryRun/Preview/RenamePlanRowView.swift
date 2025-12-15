// Views/RenamePlanRowView.swift
import SwiftUI

struct RenamePlanRowView: View {

    let plan: RenamePlan
    @State private var showDiff: Bool = true

    var body: some View {

        VStack(alignment: .leading, spacing: 6) {

            Text("Before")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(plan.originalName)
                .font(.body)

            Text("After")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)

            DiffBuilder.highlightDiff(
                old: plan.originalName,
                new: plan.targetName
            )
            .font(.body)
            .fontWeight(.semibold)

            if !plan.warnings.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("\(plan.warnings.count) warning")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 6)
    }
}
