// Services/RoleDetectionService+UserDecision.swift
import Foundation

extension DefaultRoleDetectionService {

    /// ユーザー判断（Subtitle扱いする/しない）を反映した Role 判定
    ///
    /// - Parameters:
    ///   - tokens: 解析トークン
    ///   - userDecision: ユーザーが「maybeSubtitle」をどう扱うか
    /// - Returns: RoleDetectionResult（author/title/subtitle 等）
    func detectRoles(
        from tokens: NameTokens,
        userDecision: UserSubtitleDecision
    ) -> RoleDetectionResult {

        // まずは通常の自動判定を走らせる
        let base = detectRoles(from: tokens)

        // maybeSubtitle が存在しないなら、そのまま返す
        guard let maybe = base.maybeSubtitle else {
            return base
        }

        // ユーザー判断で確定させる
        switch userDecision {
        case .undecided:
            // まだ決めていない → 自動判定のまま（maybeSubtitle が残る）
            return base

        case .confirmAsSubtitle:
            // Subtitleとして確定 → subtitle に入れて maybeSubtitle は消す
            return RoleDetectionResult(
                author: base.author,
                title: base.title,
                subtitle: maybe,
                maybeSubtitle: nil
            )

        case .ignore:
            // Subtitle扱いしない → subtitle はそのまま（通常は nil） / maybeSubtitle は消す
            return RoleDetectionResult(
                author: base.author,
                title: base.title,
                subtitle: base.subtitle,
                maybeSubtitle: nil
            )
        }
    }
}
