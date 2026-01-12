// Models/RenameSource.swift
//
// リネーム結果の発生源
//

import Foundation

enum RenameSource: String, Codable {
    case automatic
    case manual
    case imported
}
