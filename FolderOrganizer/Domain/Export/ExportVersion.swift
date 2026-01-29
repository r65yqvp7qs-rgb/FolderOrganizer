// FolderOrganizer/Domain/Export/ExportVersion.swift
//
// Export(JSON) のスキーマバージョン。
// - v0.2 の主目的「JSON Export」用のバージョニング基盤
// - 将来 Import / 互換維持を見据えて、ここを起点に分岐できるようにする
//

import Foundation

enum ExportVersion: String, Codable, Hashable {
    case v1
}
