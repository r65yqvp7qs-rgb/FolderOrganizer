//  Views/RenameDetailView.swift

import SwiftUI

struct RenameDetailView: View {
    let item: RenameItem
    let index: Int
    let total: Int
    let onPrev: () -> Void
    let onNext: () -> Void

    // 一覧と同じルールで背景色を決める
    private var detailBackground: Color {
        if TextClassifier.isSubtitle(item.normalized) {
            return Color.blue.opacity(0.10)
        }
        if TextClassifier.isPotentialSubtitle(item.normalized) {
            return Color.yellow.opacity(0.12)
        }
        return Color.white
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // 旧
            Group {
                Text("旧:")
                    .font(.system(size: 18, weight: .bold))

                Text(item.original)
                    .font(.system(size: 24))
                    .fixedSize(horizontal: false, vertical: true)
            }

            // 新（␣ を赤＋太字）
            Group {
                Text("新:")
                    .font(.system(size: 18, weight: .bold))

                DiffBuilder.highlightSpaces(in: item.normalized)
                    .font(.system(size: 24, weight: .bold))   // 大きく表示
                    .foregroundColor(AppTheme.colors.newText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            // ↑↓ ナビゲーション
            HStack {
                Button("↑ 前へ") { onPrev() }
                    .keyboardShortcut(.upArrow)

                Spacer()

                Text("\(index + 1) / \(total)")
                    .font(.system(size: 16))

                Spacer()

                Button("↓ 次へ") { onNext() }
                    .keyboardShortcut(.downArrow)
            }
            .font(.system(size: 16))
        }
        .padding(24)
        .frame(minWidth: 900, minHeight: 500)
        .background(detailBackground)
    }
}
