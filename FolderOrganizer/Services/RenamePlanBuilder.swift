//
//  RenamePlanBuilder.swift
//  FolderOrganizer
//
//  RenamePlan を組み立てる責務を持つ Builder
//

import Foundation

// MARK: - Protocol

protocol RenamePlanBuilder {
    func build(
        originalURL: URL,
        originalName: String,
        normalizedName: String,
        roles: RoleDetectionResult,
        context: ContextInfo
    ) -> RenamePlan
}

// MARK: - Default Implementation

final class DefaultRenamePlanBuilder: RenamePlanBuilder {

    func build(
        originalURL: URL,
        originalName: String,
        normalizedName: String,
        roles: RoleDetectionResult,
        context: ContextInfo
    ) -> RenamePlan {

        // MARK: - Target Parent
        let targetParentFolder = context.currentParent

        // MARK: - Target Name
        let targetName = buildTargetName(
            title: roles.title,
            subtitle: roles.subtitle
        )

        // MARK: - Warnings
        var warnings: [RenameWarning] = []

        // 作者未検出
        if roles.author == nil {
            warnings.append(.authorNotDetected)
        }

        // サブタイトル曖昧
        if let maybe = roles.maybeSubtitle {
            warnings.append(.ambiguousSubtitle(maybe))
        }

        // 同名存在（DryRun では仮判定）
        if context.duplicateNameExists {
            warnings.append(.duplicateNameExists)
        }

        // MARK: - Build RenamePlan
        return RenamePlan(
            originalURL: originalURL,
            originalName: originalName,
            normalizedName: normalizedName,

            detectedAuthor: roles.author,
            title: roles.title,
            subtitle: roles.subtitle,
            maybeSubtitle: roles.maybeSubtitle,

            targetParentFolder: targetParentFolder,
            targetName: targetName,

            warnings: warnings
        )
    }

    // MARK: - Helpers

    /// title / subtitle から最終的なフォルダ名を生成
    private func buildTargetName(
        title: String,
        subtitle: String?
    ) -> String {

        guard let subtitle, !subtitle.isEmpty else {
            return title
        }

        return "\(title) \(subtitle)"
    }
}
