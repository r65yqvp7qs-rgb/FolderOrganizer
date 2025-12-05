import Foundation

struct RenameItem: Identifiable {
    let id = UUID()
    let original: String
    var normalized: String
    var flagged: Bool = false
}
