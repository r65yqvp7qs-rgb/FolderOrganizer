//
//  Models/UndoResult.swift
//  FolderOrganizer
//
//  Undo 実行結果を表す Domain モデル
//

import Foundation

enum UndoResult: Identifiable {

    case success(RollbackInfo.Move)
    case failure(RollbackInfo.Move, Error)

    var id: String {
        switch self {
        case .success(let move):
            return "success-\(move.id.uuidString)"
        case .failure(let move, _):
            return "failure-\(move.id.uuidString)"
        }
    }

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}
