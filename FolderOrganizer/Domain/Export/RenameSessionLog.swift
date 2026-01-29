// FolderOrganizer/Domain/Export/RenameSessionLog.swift
//
// Rename フロー全体の Export(JSON) ログ（v0.2 の主目的）。
// - 自動保存（AutoSave）前提なので「いつ保存しても壊れない形」にする
// - プレビュー段階でも保存できるよう、applyLogs は optional
// - 将来の分析/学習ループに使える最低限のメタ情報を同梱
//

import Foundation

struct RenameSessionLog: Identifiable, Codable, Hashable {

    // MARK: - Identity

    /// sessionID（ログ単位）
    let id: UUID

    // MARK: - Versioning

    let version: ExportVersion

    // MARK: - Timestamps

    /// ログ生成日時（自動保存の実行時刻）
    let createdAt: Date

    /// Apply を実行した場合のみ入る
    let appliedAt: Date?

    // MARK: - Root

    /// 対象ルートフォルダ（フルパス）
    let rootPath: String

    // MARK: - Plans

    /// その時点の RenamePlan のスナップショット
    let planLogs: [RenamePlanLog]

    // MARK: - Apply (Optional)

    /// Apply 結果（Apply を未実行なら nil）
    let applyResultLogs: [ApplyResultLog]?

    /// Undo のための move 情報（Apply を未実行なら nil）
    let rollbackMoves: [RollbackMoveLog]?

    // MARK: - Init

    init(
        id: UUID = UUID(),
        version: ExportVersion = .v1,
        createdAt: Date = Date(),
        appliedAt: Date? = nil,
        rootPath: String,
        planLogs: [RenamePlanLog],
        applyResultLogs: [ApplyResultLog]? = nil,
        rollbackMoves: [RollbackMoveLog]? = nil
    ) {
        self.id = id
        self.version = version
        self.createdAt = createdAt
        self.appliedAt = appliedAt
        self.rootPath = rootPath
        self.planLogs = planLogs
        self.applyResultLogs = applyResultLogs
        self.rollbackMoves = rollbackMoves
    }
}

// MARK: - RollbackMoveLog

struct RollbackMoveLog: Codable, Hashable {

    /// いま存在する場所（Undo 実行時に from）
    let fromPath: String

    /// 元の場所（Undo 実行時に to）
    let toPath: String

    init(fromPath: String, toPath: String) {
        self.fromPath = fromPath
        self.toPath = toPath
    }
}

// MARK: - Factory

extension RenameSessionLog {

    /// プレビュー段階のスナップショット（Apply 未実行）
    static func previewSnapshot(
        rootURL: URL,
        plans: [RenamePlan]
    ) -> RenameSessionLog {
        RenameSessionLog(
            rootPath: rootURL.path,
            planLogs: plans.map { RenamePlanLog.from(plan: $0) },
            applyResultLogs: nil,
            rollbackMoves: nil
        )
    }

    /// Apply 実行済みスナップショット
    static func appliedSnapshot(
        rootURL: URL,
        plans: [RenamePlan],
        results: [ApplyResult],
        rollbackInfo: RollbackInfo,
        appliedAt: Date = Date()
    ) -> RenameSessionLog {

        let planLogs = plans.map { RenamePlanLog.from(plan: $0) }

        /// results は plans と同じ順番で返る想定だが、
        /// Export は planID で紐付ける形にして事故を避ける。
        let applyLogs: [ApplyResultLog] = zip(plans, results).map { plan, result in
            ApplyResultLog.from(planID: plan.id, result: result)
        }

        let moves: [RollbackMoveLog] = rollbackInfo.moves.map {
            RollbackMoveLog(fromPath: $0.from.path, toPath: $0.to.path)
        }

        return RenameSessionLog(
            rootPath: rootURL.path,
            planLogs: planLogs,
            applyResultLogs: applyLogs,
            rollbackMoves: moves,
            appliedAt: appliedAt
        )
    }
}
