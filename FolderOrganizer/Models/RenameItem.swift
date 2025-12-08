// Models/RenameItem.swift
import Foundation

/// 1行ぶんのリネームデータ
struct RenameItem: Identifiable, Hashable {
    let id = UUID()

    var original: String      // 元名
    var normalized: String    // 正規化後（＝「新」）
    var flagged: Bool         // 「おかしい？」フラグ

    /// 自動でサブタイトルと判定されたもの
    var isSubtitle: Bool {
        TextClassifier.isSubtitle(normalized)
    }

    /// サブタイトルの可能性あり（要チェック）
    var isPotentialSubtitle: Bool {
        TextClassifier.isPotentialSubtitle(normalized)
    }
}
