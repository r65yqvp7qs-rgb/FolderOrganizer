//
//  UI/ApplyConfirmationRowView.swift
//  FolderOrganizer
//

import SwiftUI

struct ApplyConfirmationRowView: View {
    let plan: RenamePlan

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // warnings が空なら何も出さない（好みで表示してもOK）
            if !plan.warnings.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(plan.warnings, id: \.self) { warning in
                        Label {
                            Text(warning.message)
                        } icon: {
                            Image(systemName: warningIcon(for: warning))
                        }
                        .foregroundStyle(warningColor(for: warning))
                    }
                }
                .padding(.vertical, 6)
            }
        }
    }
}

// MARK: - UI Mapping（ここでUI表現を決める）

private extension ApplyConfirmationRowView {

    func warningIcon(for warning: RenameWarning) -> String {
        switch warning {
        case .authorNotDetected:
            return "person.crop.circle.badge.questionmark"

        case .ambiguousSubtitle:
            return "questionmark.circle"

        case .duplicateNameExists:
            return "exclamationmark.triangle"

        case .fullWidthSpaceReplaced:
            return "arrow.left.and.right"

        case .multipleSpacesCollapsed:
            return "arrow.triangle.2.circlepath"
        }
    }

    func warningColor(for warning: RenameWarning) -> Color {
        switch warning {
        case .authorNotDetected, .duplicateNameExists:
            return .red

        case .ambiguousSubtitle:
            return .orange

        case .fullWidthSpaceReplaced, .multipleSpacesCollapsed:
            return .secondary
        }
    }
}
