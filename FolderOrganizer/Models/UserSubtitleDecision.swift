// Models/UserSubtitleDecision.swift
import Foundation

/// 「maybeSubtitle（要確認）」に対してユーザーがどう扱うかの意思決定
///
/// - undecided: まだ決めていない（確認画面を出す対象）
/// - confirmAsSubtitle: Subtitleとして確定させる
/// - ignore: Subtitle扱いしない（通常のタイトル側に残す）
enum UserSubtitleDecision: String, Codable, Hashable {
    case undecided
    case confirmAsSubtitle
    case ignore
}
