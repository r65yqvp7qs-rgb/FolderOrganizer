//  Views/RenamePreviewRow.swift

import SwiftUI

struct RenamePreviewRow: View {
    let original: String
    let normalized: String
    let isOdd: Bool
    @Binding var flagged: Bool

    // MARK: - 背景色（長音符はここでは判定しない）
    private var backgroundColor: Color {
        if TextClassifier.isSubtitle(normalized) {
            // サブタイトル確定（〜 / ～ / ~ の両端が揃うパターン）
            return Color.blue.opacity(0.10)
        }
        if TextClassifier.isPotentialSubtitle(normalized) {
            // サブタイトル候補（長音符など：要手動確認）
            return Color.yellow.opacity(0.12)
        }
        // 通常行（シマシマ）
        return isOdd ? Color.gray.opacity(0.08) : Color.white
    }

    private var originalTextColor: Color {
        Color.black.opacity(0.75)
    }

    private var normalizedTextColor: Color {
        Color.black
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {

                // 旧
                Text("旧: \(original)")
                    .font(.system(size: 15))
                    .foregroundColor(originalTextColor)
                    .fixedSize(horizontal: false, vertical: true)

                // 新（␣ を赤＋太字で）
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("新:")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.blue)

                    DiffBuilder.highlightSpaces(in: normalized)
                        .font(.system(size: 17, weight: .semibold))   // ★ 17pt
                        .foregroundColor(normalizedTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // フラグ
                Toggle(isOn: $flagged) {
                    Text("おかしい？")
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                }
                .toggleStyle(.checkbox)
                .padding(.top, 4)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)   // ★ 行幅を親いっぱいに
        .background(backgroundColor)
        .cornerRadius(6)
    }
}
