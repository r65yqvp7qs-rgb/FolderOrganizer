// Models/RenameSource.swift
//
// RenameItem がどこから来たかを示す
// - 自動生成 / 手編集 / Import
//

import Foundation

enum RenameSource: String, Codable, Hashable {

    /// NameNormalizer による自動生成
    case auto

    /// ユーザーが手編集した
    case manual

    /// JSON などからの Import
    case imported
}
