// Models/RenameIssue.swift
//
// RenameItem が抱える注意点・警告
//

import Foundation

enum RenameIssue: String, Codable, CaseIterable {
    case subtitle
    case potentialSubtitle
}
