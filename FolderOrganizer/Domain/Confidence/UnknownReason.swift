// Domain/Confidence/UnknownReason.swift
//
// フォルダが UNKNOWN と判定された理由
// - D-3 方針：理由が空でも最低 1 つは入れる
//

import Foundation

enum UnknownReason: String, Equatable, Identifiable {

    case noRuleMatched          // どのルールにも当てはまらなかった
    case leafFolder             // 子を持たないフォルダ
    case containsDLMarker       // [DL] / DL版 などを含む
    case containsEpisodeNumber  // 第01話 / 01-03 などを含む
    case containsDateStamp      // 日付っぽい表記を含む

    // MARK: - Identifiable
    var id: String { rawValue }

    // MARK: - 表示用テキスト（UI専用）
    var description: String {
        switch self {
        case .noRuleMatched:
            return "判定ルールに一致しませんでした"
        case .leafFolder:
            return "子フォルダを持たないフォルダです"
        case .containsDLMarker:
            return "DL マーカーを含んでいます"
        case .containsEpisodeNumber:
            return "話数・番号らしき表記を含んでいます"
        case .containsDateStamp:
            return "日付らしき表記を含んでいます"
        }
    }
}
