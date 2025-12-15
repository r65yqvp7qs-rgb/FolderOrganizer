// Views/RenamePreviewRow.swift
import SwiftUI

struct RenamePreviewRow: View {

    let original: String
    let displayName: String
    let isOdd: Bool
    let isSelected: Bool
    let isModified: Bool
    @Binding var flagged: Bool

    private var backgroundColor: Color {
        if isSelected {
            return AppTheme.colors.subtitleBackground
        }
        return isOdd
            ? AppTheme.colors.cardBackground
            : AppTheme.colors.background
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {

            // 旧名
            Text(original)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.colors.oldText)
                .frame(width: 260, alignment: .leading)

            // 新名（差分ハイライト）
            VStack(alignment: .leading, spacing: 6) {

                DiffBuilder.highlightDiff(
                    old: original,
                    new: displayName
                )
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.colors.newText)

                if isModified {
                    Text("編集済み")
                        .font(.system(size: 10, weight: .semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(AppTheme.colors.potentialSubtitleStrong.opacity(0.8))
                        .cornerRadius(4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Toggle("", isOn: $flagged)
                .labelsHidden()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(backgroundColor)
        .cornerRadius(8)
    }
}
