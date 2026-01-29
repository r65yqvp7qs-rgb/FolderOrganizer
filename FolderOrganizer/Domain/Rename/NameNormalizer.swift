// FolderOrganizer/Domain/Rename/NameNormalizer.swift
//
// ファイル／フォルダ名の正規化を行うユーティリティ
// ・意味解釈や判定は行わない
// ・RenamePlan / AutoRename とは無関係
//

import Foundation

enum NameNormalizer {

    /// 正規化結果
    struct Result {
        let original: String
        let normalized: String
    }

    // MARK: - Public

    static func normalize(_ name: String) -> Result {
        let original = name

        var normalized = name

        // 前後空白除去
        normalized = normalized.trimmingCharacters(in: .whitespacesAndNewlines)

        // 連続スペースを1つに
        normalized = normalized.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        )

        return Result(
            original: original,
            normalized: normalized
        )
    }
}
