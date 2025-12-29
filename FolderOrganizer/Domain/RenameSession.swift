// Domain/RenameSession.swift
import Foundation
import Combine

/// リネーム全体の状態管理（STEP C 用・最小）
final class RenameSession: ObservableObject {

    /// 全アイテム
    @Published var items: [RenameItem]

    /// 選択中 ID
    @Published var selectedID: UUID?

    /// 編集中フラグ
    @Published var isEditing: Bool = false

    init(items: [RenameItem]) {
        self.items = items
        self.selectedID = items.first?.id
    }

    // MARK: - Editing Control

    func startEditing() {
        isEditing = true
    }

    func finishEditing() {
        isEditing = false
    }
}
