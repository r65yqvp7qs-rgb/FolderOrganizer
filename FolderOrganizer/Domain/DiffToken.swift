// Domain/DiffToken.swift

import Foundation

/// Diff の種類
enum DiffKind: Equatable {
    case same        // 変化なし
    case added       // 新しく追加された文字
    case replaced    // 置き換えられた文字（旧→新）
}

/// Diff 表示用トークン
struct DiffToken: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let kind: DiffKind
}
