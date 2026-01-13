//
//  Services/Undo/RenameUndoService.swift
//
//  Undo 実行 Service の抽象定義
//

import Foundation

protocol RenameUndoService {

    /// Undo を実行する
    func undo(_ rollback: RollbackInfo) -> [UndoResult]
}
