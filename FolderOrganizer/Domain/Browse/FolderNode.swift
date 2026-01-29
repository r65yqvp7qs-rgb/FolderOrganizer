// Domain/Browse/FolderNode.swift
//
// フォルダツリーの 1 ノードを表すモデル
// - Tree 構築（FolderTreeBuilder）後に
//   D-3: 確信度評価を bottom-up で確定させる
//

import Foundation

struct FolderNode: Identifiable {

    // MARK: - Identity

    let id = UUID()

    // MARK: - Core Properties

    let url: URL
    let name: String
    let fileCount: Int

    /// フォルダの役割ヒント（SERIES / VOLUME / UNKNOWN）
    var roleHint: FolderRoleHint

    /// 確信度（D-3 で後から確定）
    var confidence: FolderConfidence

    /// 子フォルダ（なければ nil）
    var children: [FolderNode]?

    // MARK: - D-3: Role Fixup（B-2 補助）

    /// 子フォルダの内容から、親の roleHint を補正する
    /// - 子に volume が含まれていれば series とみなす
    mutating func fixupRoleFromChildren() {

        guard let children else { return }

        let hasVolumeChild = children.contains { $0.roleHint == .volume }

        if hasVolumeChild {
            roleHint = .series
        }
    }

    // MARK: - D-3: Confidence Fixup

    /// 子 → 親 の順で確信度を確定させる
    mutating func fixupConfidence(parent: FolderNode?) {

        let evaluator = FolderConfidenceEvaluator()

        // ① まず子を先に評価
        if var children {
            for index in children.indices {
                children[index].fixupConfidence(parent: self)
            }
            self.children = children
        }

        // ② 自分自身の確信度を評価
        confidence = evaluator.evaluate(
            node: self,
            parent: parent
        )
    }
}
