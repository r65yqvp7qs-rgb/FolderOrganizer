// Views/RenamePreviewRow.swift
import SwiftUI

struct RenamePreviewRow: View {

    let item: RenameItem
    let index: Int
    @Binding var flagged: Bool
    let isSelected: Bool

    var body: some View {

        /// 背景色ロジック
        let background: Color = {
            if item.isSubtitle {
                return AppTheme.colors.subtitleBackground
            } else if item.isPotentialSubtitle {
                return AppTheme.colors.potentialSubtitleBackground
            } else {
                return index.isMultiple(of: 2)
                    ? AppTheme.colors.rowAltBackground
                    : AppTheme.colors.cardBackground
            }
        }()

        VStack(alignment: .leading, spacing: 6) {

            // 旧
            HStack(alignment: .firstTextBaseline) {
                Text("旧:")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(AppTheme.colors.oldText)
                Text(item.original)
                    .font(.system(size: 13))
                    .foregroundColor(.primary)
            }

            // 新
            HStack(alignment: .firstTextBaseline) {
                Text("新:")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(AppTheme.colors.newText)
                Text(item.normalized)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.colors.newText)
            }

            Toggle(isOn: $flagged) {
                Text("おかしい？")
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.colors.checkLabel)
            }
            .toggleStyle(.checkbox)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)   // ← ★これ！
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? AppTheme.colors.selectedBorder : .clear, lineWidth: 2)
        )
    }
}
