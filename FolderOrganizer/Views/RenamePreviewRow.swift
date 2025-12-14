// Views/RenamePreviewRow.swift
import SwiftUI

struct RenamePreviewRow: View {

    let item: RenameItem
    let index: Int
    @Binding var flagged: Bool
    let isSelected: Bool

    private var isOdd: Bool { index % 2 == 1 }

    var body: some View {
        HStack(spacing: 10) {

            Toggle("", isOn: $flagged)
                .toggleStyle(.checkbox)
                .labelsHidden()

            VStack(alignment: .leading, spacing: 4) {

                attributedText(item.original, color: AppTheme.colors.oldText)

                attributedText(item.normalized, color: AppTheme.colors.newText)
            }

            Spacer()
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? AppTheme.colors.selectedBorder : .clear, lineWidth: 2)
        )
    }

    private var backgroundColor: Color {
        if item.isSubtitle {
            return AppTheme.colors.subtitleBackground
        }
        if item.isPotentialSubtitle {
            return AppTheme.colors.potentialSubtitleBackground
        }
        return isOdd ? AppTheme.colors.rowAltBackground : AppTheme.colors.cardBackground
    }

    @ViewBuilder
    private func attributedText(_ text: String, color: Color) -> some View {
        Text(makeAttributedString(text))
            .font(.system(.body, design: .monospaced))
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func makeAttributedString(_ text: String) -> AttributedString {
        var result = AttributedString()
        for ch in text {
            if ch == " " {
                var a = AttributedString("␣")
                a.foregroundColor = AppTheme.colors.spaceMarkerHalf
                result.append(a)
            } else if ch == "　" {
                var a = AttributedString("▢")
                a.foregroundColor = AppTheme.colors.spaceMarkerFull
                result.append(a)
            } else {
                result.append(AttributedString(String(ch)))
            }
        }
        return result
    }
}
