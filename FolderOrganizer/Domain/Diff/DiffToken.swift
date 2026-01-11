//
//  Domain/Diff/DiffToken.swift
//
//  Diff 表示用の最小トークン定義
//

import Foundation

/// Diff 表示用トークン
struct DiffToken: Identifiable {
    let id = UUID()

    let character: String
    let isChanged: Bool
}
