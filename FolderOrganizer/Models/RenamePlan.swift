// Models/RenamePlan.swift
//
// 1つのファイル／フォルダに対する「リネーム計画」を表すモデル。
// Apply / Undo / Export / 学習用途のすべての基準点となる。
// このモデルが「真実のソース」。
//

import Foundation

struct RenamePlan: Identifiable {

    let id = UUID()

    /// 元の URL
    let originalURL: URL

    /// リネーム後の URL（Apply 時に使用）
    let destinationURL: URL

    /// 元の名前
    let originalName: String

    /// 正規化後の名前（候補）
    var normalizedName: String

    /// 役割検出結果
    let roles: [DetectedRole]

    /// 親フォルダなどの文脈情報
    let context: ContextInfo

    /// 正規化結果（warnings / appliedRules など）
    let normalizeResult: NameNormalizer.Result
}
