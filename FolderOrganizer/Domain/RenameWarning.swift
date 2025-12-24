import Foundation

enum RenameWarning: Hashable {

    /// 作者が検出できなかった
    case authorNotDetected

    /// サブタイトルが曖昧
    case ambiguousSubtitle(String)

    /// 同名フォルダが既に存在する
    case duplicateNameExists

    /// 表示用メッセージ
    var message: String {
        switch self {
        case .authorNotDetected:
            return "作者名を検出できませんでした"

        case .ambiguousSubtitle(let subtitle):
            return "サブタイトルの解釈が曖昧です: \(subtitle)"

        case .duplicateNameExists:
            return "同名のフォルダが既に存在します"
        }
    }
}
