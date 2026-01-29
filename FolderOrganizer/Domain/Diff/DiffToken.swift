// Domain/Diff/DiffToken.swift

import Foundation

/// Diff 表示用の最小トークン
/// DiffOperation は既存定義を使用する（再定義しない）
struct DiffToken: Identifiable {
    let id = UUID()

    let char: Character
    let operation: DiffOperation
}
