//
//  Models/Diff/DiffToken.swift
//
//  Diff 表示用トークン
//

import Foundation

struct DiffToken: Identifiable {
    let id = UUID()

    let text: String
    let kind: Kind

    enum Kind {
        case added
        case removed
        case same
    }
}
