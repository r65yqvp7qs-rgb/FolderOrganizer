// FolderOrganizer/Services/FileScanService.swift
//
// 指定されたフォルダ配下をスキャンし、URL 一覧を返す Service
// ・root フォルダ自身は含めない
// ・ファイル / フォルダは区別しない（v0.2 初期段階）
// ・Rename / Diff / Apply とは完全に独立
//

import Foundation

final class FileScanService {

    // MARK: - Public

    func scan(folderURL: URL) throws -> [URL] {
        let fileManager = FileManager.default

        guard let enumerator = fileManager.enumerator(
            at: folderURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles],
            errorHandler: nil
        ) else {
            return []
        }

        var results: [URL] = []

        for case let url as URL in enumerator {
            // root 自身は除外
            if url == folderURL { continue }
            results.append(url)
        }

        return results
    }
}
