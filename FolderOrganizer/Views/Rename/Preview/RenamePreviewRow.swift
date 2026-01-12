//
//  Views/Rename/Preview/RenamePreviewRow.swift
//
//  Inline Edit Row
//  ・差分判定は original / normalized 比較のみ
//  ・編集状態と差分状態を分離
//

import SwiftUI

struct RenamePreviewRow: View {

    // MARK: - Inputs

    let plan: RenamePlan
    let isSelected: Bool
    let showSpaceMarkers: Bool

    let onCommit: (String) -> Void
    let onCancel: () -> Void

    // MARK: - State

    @State private var editingText: String = ""
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool

    // MARK: - Constants

    private let editFontSize: CGFloat = 15 * 1.8

    /// 差分があるか（唯一の判定）
    private var hasDiff: Bool {
        plan.originalURL.lastPathComponent != plan.item.finalName
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: 10) {

            // 差分インジケータ（編集状態とは無関係）
            Image(systemName: hasDiff ? "pencil.circle.fill" : "circle")
                .foregroundColor(hasDiff ? .accentColor : .secondary)
                .frame(width: 18)

            VStack(alignment: .leading, spacing: 4) {

                if isEditing {

                    // 編集時：元の名前（参照用）
                    Text(plan.originalURL.lastPathComponent)
                        .font(.system(size: editFontSize, design: .monospaced))
                        .foregroundStyle(.secondary)
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
                        original: plan.originalURL.lastPathComponent,
                        normalized: plan.item.finalName,
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
                editingText = plan.item.finalName
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
        switch press.key {
        case .return:
            isEditing = false
            onCommit(editingText)
            return .handled

        case .escape:
            isEditing = false
            onCancel()
            return .handled

        default:
            return .ignored
        }
    }
}
