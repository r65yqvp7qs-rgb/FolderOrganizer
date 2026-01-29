// Domain/Browse/FolderRoleHintBuilder.swift
//
// フォルダ名と親の roleHint から、現在の roleHint を推定する
// B-2: 既存ロジック（最小・保守的）
// - 名前ベースで判定
// - 親ヒントは「UNKNOWN を上書きしない」程度に使用
//

import Foundation

enum FolderRoleHintBuilder {

    static func build(
        name: String,
        parentRoleHint: FolderRoleHint?
    ) -> FolderRoleHint {

        // --- 名前ベース判定（最優先）
        if looksLikeVolume(name) {
            return .volume
        }

        // --- 親が SERIES の場合、UNKNOWN は SERIES 扱い
        if parentRoleHint == .series {
            return .series
        }

        return .unknown
    }

    // MARK: - Heuristics

    private static func looksLikeVolume(_ name: String) -> Bool {

        // 例:
        // 第01巻 / 01巻 / v01 / vol.2 / 02話 / #03
        let patterns: [String] = [
            #"第?\d{1,3}(巻|話)"#,
            #"(v|vol\.?)\d{1,3}"#,
            #"#\d{1,3}"#
        ]

        return patterns.contains {
            name.range(of: $0, options: .regularExpression) != nil
        }
    }
}
