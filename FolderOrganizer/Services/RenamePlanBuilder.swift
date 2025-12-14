import Foundation

protocol RenamePlanBuilder {

    func build(
        originalURL: URL,
        normalizedName: String,
        roles: RoleDetectionResult,
        context: ContextInfo
    ) -> RenamePlan
}

final class DefaultRenamePlanBuilder: RenamePlanBuilder {

    func build(
        originalURL: URL,
        normalizedName: String,
        roles: RoleDetectionResult,
        context: ContextInfo
    ) -> RenamePlan {

        var warnings: [RenameWarning] = []

        if roles.author == nil {
            warnings.append(.authorNotDetected)
        }

        if let maybe = roles.maybeSubtitle {
            warnings.append(.ambiguousSubtitle(maybe))
        }

        let targetParent = context.currentParent
        let targetName = roles.title

        return RenamePlan(
            originalURL: originalURL,
            originalName: originalURL.lastPathComponent,
            normalizedName: normalizedName,
            detectedAuthor: roles.author,
            title: roles.title,
            subtitle: roles.subtitle,
            maybeSubtitle: roles.maybeSubtitle,
            targetParentFolder: targetParent,
            targetName: targetName,
            warnings: warnings
        )
    }
}
