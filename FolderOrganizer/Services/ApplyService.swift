// Services/ApplyService.swift
//
// RenamePlan を実際にファイルシステムへ適用するサービス。
// Undo 用の情報も必ず生成する。
//

import Foundation

final class ApplyService {

    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    // MARK: - Public API

    func apply(plans: [RenamePlan]) -> [ApplyResult] {
        plans.map { applySingle($0) }
    }

    // MARK: - Internal

    private func applySingle(_ plan: RenamePlan) -> ApplyResult {

        let fromURL = plan.originalURL
        let toURL = plan.destinationURL

        guard fromURL != toURL else {
            return ApplyResult(
                plan: plan,
                isSuccess: true,
                error: nil,
                undoInfo: ApplyResult.UndoInfo(from: toURL, to: fromURL)
            )
        }

        do {
            if fileManager.fileExists(atPath: toURL.path) {
                throw ApplyError.destinationAlreadyExists(toURL)
            }

            try fileManager.moveItem(at: fromURL, to: toURL)

            return ApplyResult(
                plan: plan,
                isSuccess: true,
                error: nil,
                undoInfo: ApplyResult.UndoInfo(from: toURL, to: fromURL)
            )

        } catch {
            return ApplyResult(
                plan: plan,
                isSuccess: false,
                error: error,
                undoInfo: nil
            )
        }
    }
}
