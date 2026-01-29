// FolderOrganizer/Domain/Export/RenameSessionLogAutoSaveService.swift
//
// v0.2 の主目的「JSON Export（自動保存のみ）」のための Service プロトコル。
// - UI / UseCase からはこのプロトコルだけを見て、保存先やファイルI/Oの詳細は隠蔽する
// - プレビュー段階/Apply後どちらでも「いつでも保存できる」APIにする
//

import Foundation

protocol RenameSessionLogAutoSaveService {

    /// プレビュー段階のログを自動保存する
    func autoSavePreviewSnapshot(
        rootURL: URL,
        plans: [RenamePlan]
    )

    /// Apply 後のログを自動保存する
    func autoSaveAppliedSnapshot(
        rootURL: URL,
        plans: [RenamePlan],
        results: [ApplyResult],
        rollbackInfo: RollbackInfo
    )
}
