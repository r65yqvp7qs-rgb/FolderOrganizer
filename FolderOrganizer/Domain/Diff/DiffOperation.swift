//
//  Domain/Diff/DiffOperation.swift
//
//  Diff の種類定義（STEP 3-6）
//  ・replace を追加（delete+insert を束ねる）
//

import Foundation

enum DiffOperation {
    case equal
    case insert
    case delete
    case replace   // ✅ STEP 3-6
}
