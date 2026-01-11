//
//  Domain/Diff/DiffToken.swift
//
//  Diff 表示用トークン（STEP 3-5）
//

import Foundation

struct DiffToken: Identifiable {
    let id = UUID()

    let character: String
    let operation: DiffOperation
}
