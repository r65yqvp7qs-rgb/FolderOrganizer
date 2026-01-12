// Views/Rename/Preview/RenameInlineDetailView.swift
//
// RenamePlan の詳細情報を行内に表示する View。
// 表示専用（編集なし）。
//

import SwiftUI

struct RenameInlineDetailView: View {

    let plan: RenamePlan

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            detailRow(
                title: "Original",
                value: plan.originalURL.lastPathComponent
            )

            detailRow(
                title: "Normalized",
                value: plan.item.finalName
            )

            if !plan.normalizeResult.warnings.isEmpty {
                ForEach(plan.normalizeResult.warnings, id: \.self) { warning in
                    Text("⚠︎ \(warning)")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding(.leading, 26) // アイコン分インデント
        .padding(.top, 2)
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text(title + ":")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.caption)
                .fontDesign(.monospaced)
        }
    }
}
