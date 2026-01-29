// FolderOrganizer/Domain/Plan/RenameIssue.swift
//
// RenameItem に付与される問題・注意点
// 現時点では最小定義のみ
// 将来：レベル / メッセージ / 対象範囲 などを拡張予定
//

import Foundation

enum RenameIssue: String, Codable, Hashable {
    case warning
    case error
}
