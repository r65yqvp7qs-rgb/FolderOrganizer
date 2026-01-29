// FolderOrganizer/Domain/Browse/VolumeNumberDetector.swift
//
// 巻数表記の検出（算用数字 / 漢数字 / 大字）
// - 既存の containsVolumeIndicator を残しつつ
// - Evaluator 側が呼ぶ API を containsVolumeNumber(in:) に統一する
//

import Foundation

enum VolumeNumberDetector {

    static let kanjiNumbers: [String] = [
        "一","二","三","四","五","六","七","八","九","十",
        "壱","弐","参","四","伍","六","七","八","九","拾"
    ]

    /// Evaluator 側で使う統一 API
    static func containsVolumeNumber(in text: String) -> Bool {
        return containsVolumeIndicator(text)
    }

    /// 巻数の「存在」だけを見る（現状は最小ロジック）
    static func containsVolumeIndicator(_ text: String) -> Bool {
        // 1. 算用数字
        if text.range(of: #"\d+"#, options: .regularExpression) != nil {
            return true
        }

        // 2. 漢数字
        for k in kanjiNumbers {
            if text.contains(k) {
                return true
            }
        }

        return false
    }
}
