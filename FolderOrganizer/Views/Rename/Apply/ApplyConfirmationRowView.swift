//
//  ApplyConfirmationRowView.swift
//  FolderOrganizer
//

import SwiftUI

struct ApplyConfirmationRowView: View {

    let plan: RenamePlan

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            // 元の名前
            Text(plan.originalURL.lastPathComponent)
                .font(.system(size: 12, design: .monospaced))

            // 変更後の名前（URL から取得）
            Text("→ \(plan.destinationURL.lastPathComponent)")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)

            // Warning 表示（normalizeResult から取得）
            let warnings = plan.normalizeResult.warnings
            if !warnings.isEmpty {
                ForEach(warnings.indices, id: \.self) { index in
                    Text("⚠ \(warnings[index])")
                        .font(.system(size: 11))
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(.vertical, 6)
    }
}
