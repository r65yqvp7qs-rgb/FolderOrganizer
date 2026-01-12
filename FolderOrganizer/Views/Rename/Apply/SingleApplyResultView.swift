// Views/Rename/Apply/SingleApplyResultView.swift
//
// ApplyResult 1件分を簡易表示する View。
// struct ApplyResult 前提。
//

import SwiftUI

struct SingleApplyResultView: View {

    let result: ApplyResult

    var body: some View {
        HStack(spacing: 8) {

            Image(systemName: iconName)
                .foregroundStyle(iconColor)

            VStack(alignment: .leading, spacing: 2) {

                Text(result.plan.originalURL.lastPathComponent)
                    .font(.system(size: 12, design: .monospaced))

                if let undoInfo = result.undoInfo {
                    Text("→ \(undoInfo.from.lastPathComponent)")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }

                if let error = result.error {
                    Text(error.localizedDescription)
                        .font(.system(size: 11))
                        .foregroundStyle(.red)
                }
            }
        }
    }

    private var iconName: String {
        result.isSuccess ? "checkmark.circle.fill" : "xmark.octagon.fill"
    }

    private var iconColor: Color {
        result.isSuccess ? .green : .red
    }
}
