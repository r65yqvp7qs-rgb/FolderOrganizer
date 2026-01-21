// FolderOrganizer/Domain/Session/RenameSession.swift
//
// 一覧 + 編集Overlay を持つセッション（UI状態含む）
// - selectedID: 選択行
// - isEditing/editingText: 編集Overlay状態
// - ↑↓: moveSelection
// - Enter: startEditing
// - 編集中 Enter/Esc: WrappingTextView が確定/キャンセル
//

import Foundation

final class RenameSession: ObservableObject {

    // MARK: - Data

    @Published var items: [RenameItem] = []

    // MARK: - Selection

    @Published var selectedID: RenameItem.ID?

    // MARK: - Editing (Overlay only)

    @Published var isEditing: Bool = false
    @Published var editingText: String = ""

    // MARK: - Computed

    var selectedIndex: Int? {
        guard let id = selectedID else { return nil }
        return items.firstIndex(where: { $0.id == id })
    }

    var selectedItem: RenameItem? {
        guard let idx = selectedIndex, items.indices.contains(idx) else { return nil }
        return items[idx]
    }

    // MARK: - Init

    init(items: [RenameItem] = []) {
        self.items = items
        self.selectedID = items.first?.id
    }

    // MARK: - Selection API

    func select(itemID: RenameItem.ID) {
        selectedID = itemID
    }

    func moveSelection(delta: Int) {
        guard !items.isEmpty else { return }
        let current = selectedIndex ?? 0
        var next = current + delta
        next = max(0, min(items.count - 1, next))
        selectedID = items[next].id
    }

    // MARK: - Editing API

    func startEditing() {
        guard let idx = selectedIndex, items.indices.contains(idx) else { return }
        editingText = items[idx].normalized
        isEditing = true
    }

    func finishEditing() {
        guard let idx = selectedIndex, items.indices.contains(idx) else {
            isEditing = false
            return
        }
        items[idx].normalized = editingText
        isEditing = false
    }

    func cancelEditing() {
        isEditing = false
    }
}
