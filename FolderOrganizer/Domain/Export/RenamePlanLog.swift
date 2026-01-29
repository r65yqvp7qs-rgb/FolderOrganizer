// FolderOrganizer/Domain/Export/RenamePlanLog.swift
//
// RenamePlan を「Export 用に固定化」したスナップショット。
// - Domain の RenamePlan / RenameItem は将来拡張されうるため、Export 側は安定スキーマを優先
// - URL は JSON 化しやすいよう path(String) に落とす
// - ApplyResult との紐付けは planID(UUID) を使う（順序依存を避ける）
//

import Foundation

struct RenamePlanLog: Identifiable, Codable, Hashable {

    // MARK: - Identity

    /// RenamePlan.id と同一（planID）
    let id: UUID

    // MARK: - Paths (as String)

    /// 元のフルパス
    let originalPath: String

    /// 移動先親フォルダのフルパス
    let targetParentPath: String

    // MARK: - Names

    /// 元のファイル名（lastPathComponent）
    let originalName: String

    /// ユーザー編集後の名前（未編集なら nil）
    let editedName: String?

    /// 実際に適用される最終名（editedName ?? originalName）
    let finalName: String

    // MARK: - Meta

    /// 名前の生成元（auto / manual）
    let source: RenameItemSource

    /// 付与された issue
    let issues: [RenameIssue]

    // MARK: - Init

    init(
        id: UUID,
        originalPath: String,
        targetParentPath: String,
        originalName: String,
        editedName: String?,
        finalName: String,
        source: RenameItemSource,
        issues: [RenameIssue]
    ) {
        self.id = id
        self.originalPath = originalPath
        self.targetParentPath = targetParentPath
        self.originalName = originalName
        self.editedName = editedName
        self.finalName = finalName
        self.source = source
        self.issues = issues
    }
}

// MARK: - Factory

extension RenamePlanLog {

    /// Domain の RenamePlan から Export 用スナップショットへ変換
    static func from(plan: RenamePlan) -> RenamePlanLog {
        RenamePlanLog(
            id: plan.id,
            originalPath: plan.originalURL.path,
            targetParentPath: plan.targetParentURL.path,
            originalName: plan.item.original,
            editedName: plan.item.editedName,
            finalName: plan.item.finalName,
            source: plan.item.source,
            issues: Array(plan.item.issues).sorted { $0.rawValue < $1.rawValue }
        )
    }
}
