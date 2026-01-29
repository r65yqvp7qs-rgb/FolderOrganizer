// FolderOrganizer/Domain/Apply/ApplyResult.swift
//
// Apply 実行の結果を表す Domain モデル
// - RenamePlan や Undo 情報は持たない
// - 純粋に「結果の状態」のみを表現する
//

import Foundation

struct ApplyResult: Identifiable {

    // MARK: - Identity

    let id: UUID

    // MARK: - Status

    enum Status {
        case success
        case skipped(reason: String)
        case failure(ApplyError)
    }

    let status: Status

    // MARK: - Computed

    var isSuccess: Bool {
        if case .success = status { return true }
        return false
    }

    var isSkipped: Bool {
        if case .skipped = status { return true }
        return false
    }

    var error: ApplyError? {
        if case .failure(let e) = status { return e }
        return nil
    }

    // MARK: - Init

    init(
        id: UUID = UUID(),
        status: Status
    ) {
        self.id = id
        self.status = status
    }

    // MARK: - Factory

    static func success() -> ApplyResult {
        ApplyResult(status: .success)
    }

    static func skipped(reason: String) -> ApplyResult {
        ApplyResult(status: .skipped(reason: reason))
    }

    static func failure(_ error: ApplyError) -> ApplyResult {
        ApplyResult(status: .failure(error))
    }
}
