// FolderOrganizer/FolderOrganizer/Views/Browse/ConfidenceStarsView.swift
//
// Confidence を星で表す
// - D-3: UNKNOWN は「薄い 1★」にして存在は見えるようにする
//

import SwiftUI

struct ConfidenceStarsView: View {

    let confidence: FolderConfidence

    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<3, id: \.self) { index in
                Image(systemName: index < filledCount ? "star.fill" : "star")
                    .font(.caption2)
                    .foregroundColor(starColor)
            }
        }
    }

    private var filledCount: Int {
        switch confidence {
        case .high:
            return 3
        case .medium:
            return 2
        case .low:
            return 1
        case .unknown:
            return 1
        }
    }

    private var starColor: Color {
        switch confidence {
        case .high:
            return .green
        case .medium:
            return .yellow
        case .low:
            return .orange
        case .unknown:
            return .gray
        }
    }
}
