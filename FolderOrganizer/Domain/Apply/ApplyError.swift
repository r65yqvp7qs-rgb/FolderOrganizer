// Domain/Apply/ApplyError.swift
//
// Apply 処理中に発生するエラー定義。
// UI / Export / Undo から共通で参照される。
//

import Foundation

enum ApplyError: Hashable, LocalizedError {

    case failedToCreateDirectory(URL)
    case destinationAlreadyExists(URL)
    case fileMoveFailed(from: URL, to: URL, message: String)

    var errorDescription: String? {
        switch self {
        case .failedToCreateDirectory(let url):
            return "フォルダ作成に失敗しました: \(url.path)"

        case .destinationAlreadyExists(let url):
            return "既に存在するため適用できません: \(url.lastPathComponent)"

        case .fileMoveFailed(let from, let to, let message):
            return """
            移動に失敗しました:
            \(from.lastPathComponent) → \(to.lastPathComponent)
            \(message)
            """
        }
    }
}
