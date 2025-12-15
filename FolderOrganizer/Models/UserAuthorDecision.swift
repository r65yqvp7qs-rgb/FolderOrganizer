// Models/UserAuthorDecision.swift
import Foundation

/// Author検出に対してユーザーがどう扱うかの意思決定
///
/// 今は「とりあえずビルドを通す」ために最小構成。
/// 将来「この作者を採用」「無視」「手入力で上書き」などを追加できるようにしている。
enum UserAuthorDecision: String, Codable, Hashable {
    case undecided
    case acceptDetected   // 検出結果を採用
    case ignore           // 検出結果を無視
}
