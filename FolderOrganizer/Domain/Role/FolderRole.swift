// FolderOrganizer/Domain/Role/FolderRole.swift
//
// フォルダの役割推定（C-2）
// - 名前と親ロールから SERIES / VOLUME / UNKNOWN を推定
// - 巻数の確信度（★）は別レイヤーで評価する
//

import Foundation

func inferRole(
    name: String,
    parentRole: FolderRoleHint?
) -> FolderRoleHint {

    let normalized = name.lowercased()

    // -------------------------------------------------
    // ① 明示的な巻数表現（最優先）
    // -------------------------------------------------
    if looksLikeExplicitVolume(normalized) {
        return .volume
    }

    // -------------------------------------------------
    // ② 親が SERIES ＋ 巻数らしさあり → VOLUME
    // ※ 漢数字・数字・混在すべて VolumeNumberDetector に委譲
    // -------------------------------------------------
    if parentRole == .series,
       VolumeNumberDetector.containsVolumeNumber(in: name) {
        return .volume
    }

    // -------------------------------------------------
    // ③ SERIES らしい名前
    // -------------------------------------------------
    if looksLikeSeriesName(normalized) {
        return .series
    }

    // -------------------------------------------------
    // ④ 判定不能
    // -------------------------------------------------
    return .unknown
}

// MARK: - Heuristics

private func looksLikeExplicitVolume(_ name: String) -> Bool {
    let keywords = [
        "vol", "volume", "巻", "話", "episode", "ep"
    ]
    return keywords.contains { name.contains($0) }
}

private func looksLikeSeriesName(_ name: String) -> Bool {
    let keywords = [
        "全集", "シリーズ", "complete", "collection"
    ]
    return keywords.contains { name.contains($0) }
}
