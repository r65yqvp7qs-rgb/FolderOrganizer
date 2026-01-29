// FolderOrganizer/Infrastructure/Export/DefaultRenameSessionLogAutoSaveService.swift
//
// v0.2 の主目的「JSON Export（自動保存のみ）」の Default 実装。
// - Domain の factory（RenameSessionLog.previewSnapshot / appliedSnapshot）を使ってログを組み立てる
// - 保存は RenameSessionLogFileStore に委譲する
//

import Foundation

final class DefaultRenameSessionLogAutoSaveService: RenameSessionLogAutoSaveService {

    // MARK: - Dependencies

    private let store: RenameSessionLogFileStore

    // MARK: - Init

    init(store: RenameSessionLogFileStore = RenameSessionLogFileStore()) {
        self.store = store
    }

    // MARK: - RenameSessionLogAutoSaveService

    func autoSavePreviewSnapshot(
        rootURL: URL,
        plans: [RenamePlan]
    ) {
        let log = RenameSessionLog.previewSnapshot(
            rootURL: rootURL,
            plans: plans
        )
        store.save(log)
    }

    func autoSaveAppliedSnapshot(
        rootURL: URL,
        plans: [RenamePlan],
        results: [ApplyResult],
        rollbackInfo: RollbackInfo
    ) {
        let log = RenameSessionLog.appliedSnapshot(
            rootURL: rootURL,
            plans: plans,
            results: results,
            rollbackInfo: rollbackInfo
        )
        store.save(log)
    }
}
