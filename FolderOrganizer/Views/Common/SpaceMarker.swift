//
//  Views/Common/SpaceMarker.swift
//
//  スペース可視化ユーティリティ
//  ・半角スペース → ␣
//  ・全角スペース → □
//

import Foundation

struct SpaceMarker {

    static func visualize(_ text: String) -> String {
        var result = ""

        for scalar in text.unicodeScalars {
            switch scalar.value {
            case 0x0020: // 半角スペース
                result.append("␣")
            case 0x3000: // 全角スペース
                result.append("□")
            default:
                result.append(String(scalar))
            }
        }

        return result
    }
}
