// FolderOrganizer/Domain/Browse/RoleConfidence.swift
//
// 役割推定の確信度（C-1）
// - role（SERIES / VOLUME / UNKNOWN）とは独立
// - 「正しい / 間違い」ではなく「根拠の揃い具合」を表す
//

import SwiftUI

enum RoleConfidence {
    case low
    case medium
    case high

    var stars: String {
        switch self {
        case .low:    return "★"
        case .medium: return "★★"
        case .high:   return "★★★"
        }
    }

    var color: Color {
        switch self {
        case .low:    return .secondary
        case .medium: return .orange
        case .high:   return .green
        }
    }
}
