import SwiftUI

struct RenamePreviewRow: View {
    let original: String
    let normalized: String
    let isOdd: Bool
    let isSelected: Bool
    @Binding var flagged: Bool

    let contentWidth: CGFloat   // ← 幅固定のために追加したパラメータ

    // 🟦 背景色ロジックを戻す（これが必要！！）
    private var backgroundColor: Color {
        if TextClassifier.isSubtitle(normalized) {
            return AppTheme.colors.subtitleBackground
        }
        if TextClassifier.isPotentialSubtitle(normalized) {
            return AppTheme.colors.potentialSubtitleBackground
        }
        return isOdd ? AppTheme.colors.cardBackground
                     : AppTheme.colors.rowAltBackground
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // 旧
            HStack(alignment: .top, spacing: 4) {
                Text("旧:")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(AppTheme.colors.oldText)

                Text(original)
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.colors.oldText)
                    .frame(width: contentWidth, alignment: .leading)   // ★ 固定幅
            }

            // 新
            HStack(alignment: .top, spacing: 4) {
                Text("新:")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(AppTheme.colors.newText)

                DiffBuilder.highlightSpaces(in: normalized)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.colors.newText)
                    .frame(width: contentWidth, alignment: .leading)   // ★ 固定幅
            }

            // おかしい？
            Toggle(isOn: $flagged) {
                Text("おかしい？")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.colors.checkLabel)
            }
            .toggleStyle(.checkbox)
        }
        .padding(12)
        .background(backgroundColor) // ← ★ 修復ポイント
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? AppTheme.colors.selectedBorder : .clear,
                        lineWidth: 2)
        )
    }
}
