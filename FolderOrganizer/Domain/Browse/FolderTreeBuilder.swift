// Domain/Browse/FolderTreeBuilder.swift
//
// フォルダ URL から FolderNode のツリーを構築する
// - 役割ヒント決定（B-2：既存ロジック）
// - ツリー構築後に
//   D-3: role / confidence を bottom-up で確定
//

import Foundation

final class FolderTreeBuilder {

    // MARK: - Public

    func buildTree(from rootURL: URL) throws -> FolderNode {

        // ① 構造だけを構築
        var root = try buildNode(url: rootURL)

        // ② B-2: 子から親の roleHint 補正
        root.fixupRoleFromChildren()

        // ③ D-3: 確信度を bottom-up で確定
        root.fixupConfidence(parent: nil)

        return root
    }

    // MARK: - Core

    private func buildNode(url: URL) throws -> FolderNode {

        let name = url.lastPathComponent

        // --- 役割ヒント（B-2：既存ロジック）
        let roleHint = FolderRoleHintBuilder.build(
            name: name,
            parentRoleHint: nil
        )

        // --- 子フォルダ取得（type-check が重くならないよう分解）
        let resourceKeys: Set<URLResourceKey> = [.isDirectoryKey]

        let allItems = try FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: Array(resourceKeys),
            options: [.skipsHiddenFiles]
        )

        var childFolders: [URL] = []
        childFolders.reserveCapacity(allItems.count)

        for item in allItems {
            let values = try item.resourceValues(forKeys: resourceKeys)
            if values.isDirectory == true {
                childFolders.append(item)
            }
        }

        // --- Leaf
        if childFolders.isEmpty {
            return FolderNode(
                url: url,
                name: name,
                fileCount: allItems.count,
                roleHint: roleHint,
                confidence: .low, // ← D-3 で後から確定
                children: nil
            )
        }

        // --- Children
        let children = try childFolders.map {
            try buildNode(url: $0)
        }

        return FolderNode(
            url: url,
            name: name,
            fileCount: allItems.count,
            roleHint: roleHint,
            confidence: .low, // ← D-3 で後から確定
            children: children
        )
    }
}
