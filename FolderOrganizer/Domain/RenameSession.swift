//
// Domain/RenameSession.swift
// 一覧・編集で共有するセッション（唯一の状態源）
//

import Foundation
import SwiftUI

@MainActor
final class RenameSession: ObservableObject {

    // 一覧に表示される全アイテム
    @Published var items: [RenameItem]

    // 現在選択中のアイテムID（一覧・編集の同期キー）
    @Published var selectedID: RenameItem.ID? = nil

    // 編集シート表示中か
    @Published var isEditing: Bool = false

    init(items: [RenameItem]) {
        self.items = items
    }

    // MARK: - Derived

    /// selectedID から index を逆算（派生値）
    var selectedIndex: Int? {
        guard let id = selectedID else { return nil }
        return items.firstIndex { $0.id == id }
    }

    // MARK: - Selection Control

    /// ↑↓移動（一覧・編集 共通）
    func moveSelection(_ delta: Int) {
        guard let current = selectedIndex else { return }
        let newIndex = current + delta
        guard items.indices.contains(newIndex) else { return }
        selectedID = items[newIndex].id
    }

    /// 編集開始（一覧側の「編集」ボタンから呼ぶ）
    func startEditing(id: RenameItem.ID) {
        selectedID = id
        isEditing = true
    }

    /// 編集終了
    func closeEditing() {
        isEditing = false
    }
}
