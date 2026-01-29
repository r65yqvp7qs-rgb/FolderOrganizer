// FolderOrganizer/Views/Plan/RenamePlanRowView.swift
//
// Plan 一覧の 1 行表示
//

import SwiftUI

struct RenamePlanRowView: View {

    let plan: RenamePlan
    let showSpaceMarkers: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            let originalName = plan.originalURL.lastPathComponent
            let finalName = plan.item.finalName

            DiffTextView(
                original: originalName,
                final: finalName,
                showSpaceMarkers: showSpaceMarkers
            )

            if !plan.item.issues.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)

                    Text("\(plan.item.issues.count) issue")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .padding(.top, 2)
            }
        }
        .padding(.vertical, 6)
    }
}
