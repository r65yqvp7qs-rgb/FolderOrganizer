// Domain/Confidence/FolderConfidence.swift
//
// フォルダの役割判定に対する「確信度」
// - UNKNOWN の場合は必ず理由（UnknownReason）を保持する
// - 判定結果そのものを表す Value Object
//

import Foundation

enum FolderConfidence: Equatable {

    case high
    case medium
    case low

    /// 判定できなかった場合（理由付き）
    case unknown(reasons: [UnknownReason])
}
