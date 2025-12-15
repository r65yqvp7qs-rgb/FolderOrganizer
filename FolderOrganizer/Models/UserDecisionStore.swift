// Models/UserDecisionStore.swift
import Foundation
import Combine

/// URL（= 対象フォルダ/項目）ごとにユーザー判断を保持するストア
///
/// ポイント:
/// - Viewからは「decision(for:) / setDecision(_:for:)」だけ触ればOK
/// - @Published の辞書を更新することで、onReceive で再ビルドが走る
final class UserDecisionStore: ObservableObject {

    // MARK: - Published decision dictionaries

    /// maybeSubtitle 判定への回答
    @Published private(set) var subtitleDecisions: [URL: UserSubtitleDecision] = [:]

    /// author 判定への回答（今は最小）
    @Published private(set) var authorDecisions: [URL: UserAuthorDecision] = [:]

    // MARK: - Subtitle

    /// 対象URLの Subtitle 決定を取得（未設定なら undecided）
    func subtitleDecision(for url: URL) -> UserSubtitleDecision {
        subtitleDecisions[url] ?? .undecided
    }

    /// 対象URLの Subtitle 決定を保存
    func setSubtitleDecision(_ decision: UserSubtitleDecision, for url: URL) {
        subtitleDecisions[url] = decision
    }

    // MARK: - Author

    /// 対象URLの Author 決定を取得（未設定なら undecided）
    func authorDecision(for url: URL) -> UserAuthorDecision {
        authorDecisions[url] ?? .undecided
    }

    /// 対象URLの Author 決定を保存
    func setAuthorDecision(_ decision: UserAuthorDecision, for url: URL) {
        authorDecisions[url] = decision
    }
}
