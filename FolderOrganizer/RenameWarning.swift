import Foundation

enum RenameWarning: Identifiable {

    case authorNotDetected
    case ambiguousSubtitle(String)
    case duplicateNameExists(String)

    var id: String {
        switch self {
        case .authorNotDetected:
            return "authorNotDetected"
        case .ambiguousSubtitle(let value):
            return "ambiguousSubtitle:\(value)"
        case .duplicateNameExists(let name):
            return "duplicateNameExists:\(name)"
        }
    }

    var message: String {
        switch self {
        case .authorNotDetected:
            return "作者名を検出できませんでした"
        case .ambiguousSubtitle(let value):
            return "副題かもしれない文字列があります: \(value)"
        case .duplicateNameExists(let name):
            return "同名フォルダが既に存在します: \(name)"
        }
    }

    var isBlocking: Bool {
        switch self {
        case .authorNotDetected:
            return true
        case .ambiguousSubtitle:
            return false
        case .duplicateNameExists:
            return true
        }
    }
}
