//
// Views/Common/DiffTextView.swift
//
import SwiftUI

struct DiffTextView: View {

    let segments: [DiffSegment]
    let font: Font

    var body: some View {
        Text(rendered)
            .font(font)
    }

    private var rendered: AttributedString {
        var result = AttributedString()
        result.font = font

        for segment in segments {
            switch segment {
            case .same(let text):
                var part = AttributedString(text)
                part.font = font
                result.append(part)

            case .added(let text):
                var part = AttributedString(text)
                part.font = font
                part.foregroundColor = .green
                result.append(part)
            }
        }
        return result
    }
}
