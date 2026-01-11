//
//  Domain/Diff/DiffToken.swift
//
//  Diff 表示用トークン（STEP 3-6）
//  ・operation に replace を追加
//

import Foundation

struct DiffToken: Identifiable {
    let id = UUID()

    let character: String
    let operation: DiffOperation
}
