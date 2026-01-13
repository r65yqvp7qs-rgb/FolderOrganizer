//
//  Domain/Undo/UndoError.swift
//  FolderOrganizer
//
//  Undo（rollback）時のドメインエラー定義
//

import Foundation

enum UndoError: LocalizedError, Hashable {

    /// Undo 可能な情報が存在しない
    case notApplicable

    /// Apply 後の対象が見つからない
    case appliedItemMissing(URL)

    /// 元の場所に既に項目が存在する
    case originalLocationAlreadyExists(URL)

    /// ファイル操作失敗
    case fileOperationFailed(message: String)

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .notApplicable:
            return "Undo できる情報がありません。"

        case .appliedItemMissing(let url):
            return "Undo 対象が見つかりません: \(url.path)"

        case .originalLocationAlreadyExists(let url):
            return "元の場所に既に項目があります: \(url.path)"

        case .fileOperationFailed(let message):
            return "Undo に失敗しました: \(message)"
        }
    }
}
