// Views/Rename/Apply/ApplyResultRow.swift
//
// Apply 結果を 1 行表示するための ViewModel 用 DTO
// ApplyResult（struct）を UI 表示用に正規化する
//

import SwiftUI

struct ApplyResultRow: Identifiable {

    let id = UUID()

    let title: String
    let detail: String?
    let succeeded: Bool

    // MARK: - Init

    init(result: ApplyResult) {

        if result.error == nil {
            // 成功時
            self.title = result.plan.originalURL.lastPathComponent
            self.detail = "→ \(result.plan.destinationURL.lastPathComponent)"
            self.succeeded = true
        } else {
            // 失敗時
            self.title = "Apply 失敗"
            self.detail = result.error?.localizedDescription
            self.succeeded = false
        }
    }
}
