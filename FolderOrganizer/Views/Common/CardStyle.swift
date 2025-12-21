//
// Views/Common/CardStyle.swift
//
import SwiftUI

struct CardStyle: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(nsColor: .controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        Color(nsColor: .separatorColor).opacity(0.3),
                        lineWidth: 0.5
                    )
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
