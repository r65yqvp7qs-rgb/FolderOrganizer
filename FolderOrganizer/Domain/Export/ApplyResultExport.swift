// Domain/Export/ApplyResultExport.swift
//
// ApplyResult を JSON Export 用に変換した DTO。
// Domain モデルとは責務を分離する。
//

import Foundation

struct ApplyResultExport: Codable {

    // MARK: - Meta

    let version: ExportVersion
    let exportedAt: Date

    // MARK: - Paths

    let originalPath: String
    let appliedPath: String?

    // MARK: - Result

    let success: Bool
    let errorMessage: String?

    // MARK: - Init

    init(from result: ApplyResult) {

        self.version = .v1
        self.exportedAt = Date()

        self.originalPath = result.plan.originalURL.path

        if let undoInfo = result.undoInfo {
            self.appliedPath = undoInfo.from.path
        } else {
            self.appliedPath = nil
        }

        self.success = result.isSuccess
        self.errorMessage = result.error?.localizedDescription
    }
}
