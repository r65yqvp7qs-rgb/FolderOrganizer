// FolderOrganizer/Domain/Browse/FolderRoleHint.swift
//
// 役割推定（B-2）
// - フォルダ名から SERIES / VOLUME / UNKNOWN を推定する
//

import Foundation

enum FolderRoleHint: String, Codable {
    case series
    case volume
    case unknown

    static func detect(from folderName: String) -> FolderRoleHint {
        // 巻/話/vol/vxx を含むなら VOLUME っぽい（簡易）
        if folderName.range(of: #"(第)?\d{1,3}([\-–~]\d{1,3})?(巻|話)"#, options: .regularExpression) != nil {
            return .volume
        }

        if folderName.range(of: #"\b(v|V)\d{1,3}([\-–~]\d{1,3})?\b"#, options: .regularExpression) != nil {
            return .volume
        }

        return .unknown
    }
}
