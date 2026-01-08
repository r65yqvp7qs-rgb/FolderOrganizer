//
//  Views/Rename/Preview/RenamePreviewRow.swift
//
//  Inline Edit Row（最終形）
//  ・表示時：Text のみ
//  ・編集時：TextEditor のみ（重ねない）
//  ・Enter = 確定（改行不可）
//  ・Esc = キャンセル
//

import SwiftUI

struct RenamePreviewRow: View {

    let plan: RenamePlan
    let isSelected: Bool
    let onCommit: (String) -> Void
    let onCancel: () -> Void

    @State private var editingText: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {

            Image(systemName: plan.originalName == plan.normalizedName
                  ? "circle"
                  : "pencil.circle.fill")
                .foregroundColor(
                    plan.originalName == plan.normalizedName
                    ? .secondary
                    : .blue
                )
                .frame(width: 18)

            VStack(alignment: .leading, spacing: isSelected ? 6 : 0) {

                if isSelected {

                    // 補助（元の名前）
                    Text(plan.originalName)
                        .font(.system(size: 22, design: .monospaced))
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    // 編集用（唯一の「新」）
                    TextEditor(text: $editingText)
                        .font(.system(size: 22, weight: .semibold, design: .monospaced))
                        .foregroundColor(.primary)
                        .scrollDisabled(true)
                        .focused($isFocused)
                        .padding(.horizontal, -4)   // ← 横を詰める
                        .padding(.vertical, -6)     // ← 縦を詰める
                        .background(Color.clear)
                        .onKeyPress { event in
                            handleKey(event)
                        }

                } else {

                    // 一覧表示
                    Text(plan.normalizedName)
                        .font(.system(size: 15, design: .monospaced))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
            }

            Spacer()
        }
        .padding(.vertical, isSelected ? 10 : 6)
        .padding(.horizontal, 8)
        .background(
            isSelected
            ? Color.accentColor.opacity(0.10)
            : Color.clear
        )
        .cornerRadius(8)
        .onChange(of: isSelected) { selected in
            if selected {
                editingText = plan.normalizedName
                DispatchQueue.main.async {
                    isFocused = true
                }
            }
        }
    }

    // MARK: - Editor Height（折り返し一致用）

    private var editorHeight: CGFloat {
        let lines = editingText.split(whereSeparator: \.isNewline).count
        return max(28, CGFloat(lines) * 26)
    }

    // MARK: - Key Handling

    private func handleKey(_ event: KeyPress) -> KeyPress.Result {
        switch event.key {
        case .return:
            commit()
            return .handled

        case .escape:
            cancel()
            return .handled

        default:
            return .ignored
        }
    }

    // MARK: - Actions

    private func commit() {
        let trimmed = editingText.replacingOccurrences(of: "\n", with: "")
        onCommit(trimmed)
    }

    private func cancel() {
        editingText = plan.normalizedName
        onCancel()
    }
}
