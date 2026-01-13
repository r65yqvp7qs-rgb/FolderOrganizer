//
//  Services/Undo/DefaultRenameUndoService.swift
//
//  RenameUndoService の標準実装
//

import Foundation

final class DefaultRenameUndoService: RenameUndoService {

    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func undo(_ rollback: RollbackInfo) -> [UndoResult] {

        var results: [UndoResult] = []

        for move in rollback.moves.reversed() {
            do {
                try undoSingleMove(move)
                results.append(.success(move))
            } catch let error as UndoError {
                results.append(.failure(move, error))
            } catch {
                results.append(.failure(
                    move,
                    UndoError.fileOperationFailed(message: error.localizedDescription)
                ))
            }
        }

        return results
    }

    // MARK: - Private

    private func undoSingleMove(_ move: RollbackInfo.Move) throws {

        guard fileManager.fileExists(atPath: move.from.path) else {
            throw UndoError.appliedItemMissing(move.from)
        }

        if fileManager.fileExists(atPath: move.to.path) {
            throw UndoError.originalLocationAlreadyExists(move.to)
        }

        do {
            try fileManager.moveItem(at: move.from, to: move.to)
        } catch {
            throw UndoError.fileOperationFailed(
                message: error.localizedDescription
            )
        }
    }
}
