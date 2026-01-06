// Infrastructure/Apply/DefaultRenameApplyService.swift
//
// RenamePlan を順番に適用するデフォルト実装。
// ApplyService と同じ ApplyResult モデルを使用する。
//

import Foundation

final class DefaultRenameApplyService: RenameApplyService {

    private let fileManager: FileManager = .default

    func apply(
        plans: [RenamePlan],
        completion: @escaping ([ApplyResult]) -> Void
    ) {
        var results: [ApplyResult] = []

        for plan in plans {

            let fromURL = plan.originalURL
            let toURL = plan.destinationURL

            do {
                // MARK: - 1. Rename（move）
                if fileManager.fileExists(atPath: toURL.path) {
                    throw ApplyError.destinationAlreadyExists(toURL)
                }

                try fileManager.moveItem(
                    at: fromURL,
                    to: toURL
                )

                // MARK: - 2. Undo 情報生成
                let undoInfo = ApplyResult.UndoInfo(
                    from: toURL,
                    to: fromURL
                )

                // MARK: - 3. 成功 Result
                let result = ApplyResult(
                    plan: plan,
                    isSuccess: true,
                    error: nil,
                    undoInfo: undoInfo
                )

                results.append(result)

            } catch {

                // MARK: - 4. 失敗 Result
                let result = ApplyResult(
                    plan: plan,
                    isSuccess: false,
                    error: error,
                    undoInfo: nil
                )

                results.append(result)
            }
        }

        completion(results)
    }
}
