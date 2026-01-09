//
//  Views/Rename/Preview/RenamePreviewRow.swift
//
//  Inline Edit Row（STEP 3-1 完成版）
//  ・非編集時：上下並び Diff
//  ・編集時：元名＋TextEditor（同サイズ）
//  ・Enter = 確定
//  ・Esc = キャンセル
//

import SwiftUI

struct RenamePreviewRow: View {

    let plan: RenamePlan
    let isSelected: Bool
    let onCommit: (String) -> Void
    let onCancel: () -> Void

    @State private var editingText: String = ""
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool

    /// 非編集時 基準サイズ
    private let baseFontSize: CGFloat = 15

    /// 編集時（約1.8倍）
    private let editFontSize: CGFloat = 27

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

            VStack(alignment: .leading, spacing: 4) {

                if isEditing {
                    
                    // 編集時：元の名前（折り返し完全対応）
                    Text(plan.originalName)
                        .font(.system(size: editFontSize, design: .monospaced))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true) // ← ★重要
                    
                    // 編集対象（TextEditor）
                    TextEditor(text: $editingText)
                        .font(.system(
                            size: editFontSize,
                            weight: .semibold,
                            design: .monospaced
                        ))
                        .scrollDisabled(true)
                        .focused($isFocused)
                        .fixedSize(horizontal: false, vertical: true) // ← ★重要
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
                        normalized: plan.normalizedName
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
        // 🔧 deprecated 回避（新API）
        .onChange(of: isSelected) {
            if isSelected {
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
