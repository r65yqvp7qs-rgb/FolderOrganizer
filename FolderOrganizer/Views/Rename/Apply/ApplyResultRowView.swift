// Views/Rename/Apply/ApplyResultRowView.swift
//
// ApplyResult 1件分を表示する Row View。
// struct ApplyResult 前提の最終形。
//

import SwiftUI

struct ApplyResultRowView: View {

    let result: ApplyResult
    let index: Int

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            Image(systemName: iconName)
                .foregroundStyle(iconColor)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {

                Text("Item \(index + 1)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if result.isSuccess {
                    successView
                } else {
                    failureView
                }
            }

            Spacer()
        }
    }

    // MARK: - Success View

    private var successView: some View {
        VStack(alignment: .leading, spacing: 2) {

            Text(result.plan.originalName)
                .font(.system(size: 12, design: .monospaced))

            if let undoInfo = result.undoInfo {
                Text("→ \(undoInfo.from.lastPathComponent)")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Failure View

    private var failureView: some View {
        VStack(alignment: .leading, spacing: 2) {

            Text("Apply 失敗")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.red)

            if let error = result.error {
                Text(error.localizedDescription)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Icon

    private var iconName: String {
        result.isSuccess ? "checkmark.circle.fill" : "xmark.octagon.fill"
    }

    private var iconColor: Color {
        result.isSuccess ? .green : .red
    }
}
