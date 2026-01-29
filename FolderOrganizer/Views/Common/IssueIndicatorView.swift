// FolderOrganizer/Views/Common/IssueIndicatorView.swift
//
// RenameIssue を視覚的に示す最小インジケータ
// ・アイコン＋色のみ
// ・説明文や操作は持たない
//

import SwiftUI

struct IssueIndicatorView: View {

    let issues: Set<RenameIssue>

    var body: some View {
        if let issue = highestPriorityIssue {
            Image(systemName: iconName(for: issue))
                .foregroundColor(color(for: issue))
                .frame(width: 14)
        } else {
            // Issue なしの場合はスペース確保のみ
            Color.clear
                .frame(width: 14)
        }
    }

    // MARK: - Priority

    private var highestPriorityIssue: RenameIssue? {
        if issues.contains(.error) {
            return .error
        }
        if issues.contains(.warning) {
            return .warning
        }
        return nil
    }

    // MARK: - Appearance

    private func iconName(for issue: RenameIssue) -> String {
        switch issue {
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "xmark.octagon.fill"
        }
    }

    private func color(for issue: RenameIssue) -> Color {
        switch issue {
        case .warning:
            return AppTheme.colors.issueWarning
        case .error:
            return AppTheme.colors.issueError
        }
    }
}
