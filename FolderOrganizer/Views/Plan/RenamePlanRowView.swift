//
// Views/Plan/RenamePlanRowView.swift
//
import SwiftUI

struct RenamePlanRowView: View {

    let plan: RenamePlan
    let showSpaceMarkers: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            // 差分を生成
            let segments = DiffBuilder.build(
                old: plan.originalName,
                new: plan.targetName
            )

            // 差分表示
            DiffTextView(
                segments: segments,
                font: .system(size: 14, weight: .semibold, design: .monospaced)
            )

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
