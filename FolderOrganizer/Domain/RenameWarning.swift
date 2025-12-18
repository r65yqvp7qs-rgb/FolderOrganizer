//
//  Domain/RenameWarning.swift
//  FolderOrganizer
//
//  Domain層の警告モデル（UIに依存しない）
//

import Foundation

/// リネーム計画で発生した「警告」
/// - NOTE: Domain層なので SwiftUI(Color) など UI 型は使わない
enum RenameWarning: Hashable {
    /// 作者が検出できなかった
    case authorNotDetected

    /// Subtitle が曖昧（候補文字列を保持）
    case ambiguousSubtitle(String)

    /// 同名が存在する（DryRun時点の仮判定を含む）
    case duplicateNameExists

    /// 全角スペースを半角スペースに置換した
    case fullWidthSpaceReplaced

    /// 連続スペースを1つに畳んだ
    case multipleSpacesCollapsed
}

extension RenameWarning {
    /// UI表示用メッセージ（文言はここに集約してOK：ただしUI型は入れない）
    var message: String {
        switch self {
        case .authorNotDetected:
            return "作者が検出できませんでした"

        case .ambiguousSubtitle(let candidate):
            return "Subtitle が曖昧です（候補: \(candidate)）"

        case .duplicateNameExists:
            return "同名が存在する可能性があります"

        case .fullWidthSpaceReplaced:
            return "全角スペースを半角スペースに置換しました"

        case .multipleSpacesCollapsed:
            return "連続スペースを1つに畳みました"
        }
    }
}
