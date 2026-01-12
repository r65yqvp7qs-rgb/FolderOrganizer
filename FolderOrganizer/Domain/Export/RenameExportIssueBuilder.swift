// Domain/Export/RenameExportIssueBuilder.swift
//
// RenamePlan / RenameItem から Export 用の Issue 情報を生成する
// - STEP 4-2 以降の確定 Domain 構造に準拠
//

import Foundation

enum RenameExportIssueBuilder {

    static func build(from plans: [RenamePlan]) -> [RenameExportIssue] {
        plans.flatMap { buildIssues(from: $0) }
    }

    // MARK: - Private

    private static func buildIssues(from plan: RenamePlan) -> [RenameExportIssue] {

        var issues: [RenameExportIssue] = []

        for issue in plan.item.issues {

            let (title, message): (String, String) = {
                switch issue {
                case .subtitle:
                    return ("サブタイトル検出", "タイトル内にサブタイトルと判定される要素があります")
                case .potentialSubtitle:
                    return ("サブタイトルの可能性", "サブタイトルの可能性がある要素が含まれています")
                }
            }()

            issues.append(
                RenameExportIssue(
                    level: .warning,
                    title: title,
                    message: message,
                    originalName: plan.originalURL.lastPathComponent,
                    normalizedName: plan.item.finalName
                )
            )
        }

        return issues
    }
}
