// FolderOrganizer/Domain/Export/ApplyResultLog.swift
//
// ApplyResult を Export(JSON) できる形に落としたログ。
// - ApplyResult / ApplyError は Codable ではないため、Export 側で安定表現に変換する
// - RenamePlanLog と planID(UUID) で紐付ける
//

import Foundation

struct ApplyResultLog: Identifiable, Codable, Hashable {

    // MARK: - Identity

    /// RenamePlanLog.id と同一（planID）
    let id: UUID

    // MARK: - Status

    enum Status: String, Codable, Hashable {
        case success
        case skipped
        case failure
    }

    let status: Status

    /// skipped の場合のみ入る
    let skippedReason: String?

    /// failure の場合のみ入る
    let error: ApplyErrorLog?

    // MARK: - Init

    init(
        id: UUID,
        status: Status,
        skippedReason: String? = nil,
        error: ApplyErrorLog? = nil
    ) {
        self.id = id
        self.status = status
        self.skippedReason = skippedReason
        self.error = error
    }
}

// MARK: - ApplyErrorLog

struct ApplyErrorLog: Codable, Hashable {

    enum Kind: String, Codable, Hashable {
        case failedToCreateDirectory
        case destinationAlreadyExists
        case fileMoveFailed
    }

    let kind: Kind

    /// JSON を安定させるため、必要情報は optional で持つ（kind に応じて利用）
    let path: String?
    let fromPath: String?
    let toPath: String?
    let message: String?

    init(
        kind: Kind,
        path: String? = nil,
        fromPath: String? = nil,
        toPath: String? = nil,
        message: String? = nil
    ) {
        self.kind = kind
        self.path = path
        self.fromPath = fromPath
        self.toPath = toPath
        self.message = message
    }
}

// MARK: - Factory

extension ApplyResultLog {

    static func from(planID: UUID, result: ApplyResult) -> ApplyResultLog {
        switch result.status {
        case .success:
            return ApplyResultLog(id: planID, status: .success)

        case .skipped(let reason):
            return ApplyResultLog(id: planID, status: .skipped, skippedReason: reason)

        case .failure(let error):
            return ApplyResultLog(
                id: planID,
                status: .failure,
                error: ApplyErrorLog.from(applyError: error)
            )
        }
    }
}

extension ApplyErrorLog {

    static func from(applyError: ApplyError) -> ApplyErrorLog {
        switch applyError {
        case .failedToCreateDirectory(let url):
            return ApplyErrorLog(kind: .failedToCreateDirectory, path: url.path)

        case .destinationAlreadyExists(let url):
            return ApplyErrorLog(kind: .destinationAlreadyExists, path: url.path)

        case .fileMoveFailed(let from, let to, let message):
            return ApplyErrorLog(
                kind: .fileMoveFailed,
                fromPath: from.path,
                toPath: to.path,
                message: message
            )
        }
    }
}
