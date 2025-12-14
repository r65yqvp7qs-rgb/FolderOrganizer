import Foundation

final class RenamePlanEngine {

    private let normalizationService: NameNormalizationService
    private let tokenizationService: NameTokenizationService
    private let roleDetectionService: RoleDetectionService
    private let contextResolutionService: ContextResolutionService
    private let planBuilder: RenamePlanBuilder

    init(
        normalizationService: NameNormalizationService = DefaultNameNormalizationService(),
        tokenizationService: NameTokenizationService = DefaultNameTokenizationService(),
        roleDetectionService: RoleDetectionService = DefaultRoleDetectionService(),
        contextResolutionService: ContextResolutionService = DefaultContextResolutionService(),
        planBuilder: RenamePlanBuilder = DefaultRenamePlanBuilder()
    ) {
        self.normalizationService = normalizationService
        self.tokenizationService = tokenizationService
        self.roleDetectionService = roleDetectionService
        self.contextResolutionService = contextResolutionService
        self.planBuilder = planBuilder
    }

    /// DryRun 専用
    func generatePlan(for url: URL) -> RenamePlan {

        let rawName = url.lastPathComponent
        let normalized = normalizationService.normalize(rawName)

        let tokens = tokenizationService.tokenize(normalized)
        let roles = roleDetectionService.detectRoles(from: tokens)
        let context = contextResolutionService.resolveContext(for: url)

        return planBuilder.build(
            originalURL: url,
            normalizedName: normalized,
            roles: roles,
            context: context
        )
    }
}
