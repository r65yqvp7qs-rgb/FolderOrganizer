//
// Models/DiffSegment.swift
//
import Foundation

/// 差分表示用（削除は表に出さない方針）
/// - same: 変化なし
/// - added: 追加された文字
enum DiffSegment: Equatable {
    case same(String)
    case added(String)
}
