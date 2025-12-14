import Foundation

protocol RoleDetectionService {

    /// token から意味を確定 / 保留する
    func detectRoles(from tokens: NameTokens) -> RoleDetectionResult
}

final class DefaultRoleDetectionService: RoleDetectionService {

    func detectRoles(from tokens: NameTokens) -> RoleDetectionResult {
        // TODO: author / subtitle / maybe subtitle 判定
        return RoleDetectionResult(
            author: nil,
            title: tokens.titleCandidates.first ?? "",
            subtitle: nil,
            maybeSubtitle: nil
        )
    }
}
