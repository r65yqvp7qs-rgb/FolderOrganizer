import SwiftUI

struct RenameDetailView: View {
    @Binding var item: RenameItem
    let index: Int
    let total: Int
    let onPrev: () -> Void
    let onNext: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("詳細 (\(index + 1) / \(total))")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button("閉じる") {
                    onClose()
                }
                .keyboardShortcut(.escape, modifiers: [])
            }

            Group {
                Text("旧:")
                    .font(.system(size: 15, weight: .bold))
                Text(item.original)
                    .font(.system(size: 17))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Group {
                Text("新（編集可）:")
                    .font(.system(size: 15, weight: .bold))

                TextField("", text: $item.normalized)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 17))
                    .onSubmit(onNext)

                DiffBuilder.highlightSpaces(in: item.normalized)
                    .font(.system(size: 17))
                    .foregroundColor(AppTheme.colors.newText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            HStack {
                Button("↑ 前へ") { onPrev() }
                    .keyboardShortcut(.upArrow, modifiers: [])

                Spacer()

                Button("↓ 次へ") { onNext() }
                    .keyboardShortcut(.downArrow, modifiers: [])
            }
            .font(.system(size: 15))
        }
        .padding(24)
    }
}
