//
//  RenamePlanRowView.swift
//  FolderOrganizer
//

import SwiftUI

struct RenamePlanRowView: View {

    let plan: RenamePlan
    let showSpaceMarkers: Bool   // 呼び出し元都合なので保持でOK

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            // 元名 / 変更後名
            let originalName = plan.originalName
            let modifiedName = plan.destinationURL.lastPathComponent

            // 差分表示
            DiffTextView(
                original: originalName,
                normalized: modifiedName
            )

            // MARK: - Warning 表示
            let warnings = plan.normalizeResult.warnings

            if !warnings.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)

                    Text("\(warnings.count) warning")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 6)
    }
}
