import SwiftUI

struct RenamePreviewRow: View {
    let original: String
    let normalized: String
    let isOdd: Bool
    @Binding var flagged: Bool

    private var backgroundColor: Color {
        if TextClassifier.isSubtitle(normalized) {
            return AppTheme.colors.subtitle          // 〜〜 あり → 薄い青
        }
        if TextClassifier.isPotentialSubtitle(normalized) {
            return AppTheme.colors.maybeSubtitle     // ー あり → 薄い黄
        }
        return isOdd ? AppTheme.colors.rowStripe : AppTheme.colors.rowAltStripe
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("旧:")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.secondary)

            Text(original)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text("新:")
                .font(.system(size: 13, weight: .bold))

            DiffBuilder.highlightSpaces(in: normalized)
                .font(.system(size: 17))                     // ★ Q2: フォント 17
                .foregroundColor(AppTheme.colors.newText)
                .fixedSize(horizontal: false, vertical: true)

            Toggle(isOn: $flagged) {
                Text("おかしい？")
                    .font(.system(size: 12))
            }
            .toggleStyle(.checkbox)
            .padding(.top, 4)
        }
        .padding(12)
        .background(backgroundColor)
        .cornerRadius(8)
    }
}
