//
//  Views/Rename/Preview/RenamePreviewRow.swift
//
//  Inline Edit Row
//  ・表示時：Diff 表示
//  ・編集時：TextEditor
//  ・Enter = 確定
//  ・Esc = キャンセル
//

import SwiftUI

struct RenamePreviewRow: View {

    // MARK: - Inputs

    let plan: RenamePlan
    let isSelected: Bool

    /// スペース可視化（ContentView → List → Row で伝播）
    let showSpaceMarkers: Bool

    let onCommit: (String) -> Void
    let onCancel: () -> Void

    // MARK: - State

    @State private var editingText: String = ""
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool

    // MARK: - Constants

    private let editFontSize: CGFloat = 15 * 1.8

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: 10) {

            Image(systemName: isEditing ? "pencil.circle.fill" : "circle")
                .foregroundColor(isEditing ? .blue : .secondary)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 4) {

                if isEditing {

                    // 編集時：元の名前（比較用）
                    Text(plan.originalName)
                        .font(.system(size: editFontSize, design: .monospaced))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    // 編集対象
                    TextEditor(text: $editingText)
                        .font(.system(
                            size: editFontSize,
                            weight: .semibold,
                            design: .monospaced
                        ))
                        .scrollDisabled(true)
                        .focused($isFocused)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, -4)
                        .padding(.vertical, -6)
                        .background(Color.clear)
                        .onKeyPress { press in
                            handleKey(press)
                        }

                } else {

                    // 非編集時：Diff 表示
                    DiffTextView(
                        original: plan.originalName,
                        normalized: plan.normalizedName,
                        showSpaceMarkers: showSpaceMarkers
                    )
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
        .onChange(of: isSelected) { _, selected in
            if selected {
                editingText = plan.normalizedName
                isEditing = true
                DispatchQueue.main.async {
                    isFocused = true
                }
            } else if isEditing {
                isEditing = false
                onCancel()
            }
        }
    }

    // MARK: - Key Handling

    private func handleKey(_ press: KeyPress) -> KeyPress.Result {
        if press.key == .return {
            isEditing = false
            onCommit(editingText)
            return .handled
        }

        if press.key == .escape {
            isEditing = false
            onCancel()
            return .handled
        }

        return .ignored
    }
}
