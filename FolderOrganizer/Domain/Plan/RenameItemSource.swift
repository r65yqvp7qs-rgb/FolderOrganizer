// Domain/Plan/RenameItemSource.swift
//
// RenameItem の名前がどこから来たかを表す
//

import Foundation

enum RenameItemSource: String, Codable, Hashable {

    /// 自動生成（初期状態）
    case auto

    /// ユーザーが手動で編集
    case manual
}
