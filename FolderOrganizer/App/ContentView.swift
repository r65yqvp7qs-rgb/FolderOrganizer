// App/ContentView.swift
//
// メイン画面
// - フォルダ読み込み
// - 一覧（上下/Enter で編集開始）
// - 編集 Overlay（Enter=確定 / Esc=キャンセル）
// - wantsFocus を Binding で Overlay -> Editor へ渡して、表示直後に確実に focus する
//

import SwiftUI
import AppKit

struct ContentView: View {

    // MARK: - State

    @State private var items: [RenameItem] = []
    @State private var selectedIndex: Int? = nil

    @State private var editingIndex: Int? = nil
    @State private var editingText: String = ""

    // ✅ Overlay 表示直後に Editor へ focus させるためのフラグ（Binding で渡す）
    @State private var wantsFocus: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 24) {

                Text("Folder Organizer")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 24)

                Button("フォルダ名を読み込んで変換プレビュー") {
                    selectFolderAndLoad()
                }
                .buttonStyle(.borderedProminent)

                RenamePreviewList(
                    items: $items,
                    selectedIndex: $selectedIndex,
                    onSelect: { index in
                        selectedIndex = index
                    },
                    onEditRequest: { index in
                        startEditing(index: index)
                    }
                )
                .padding(.bottom, 24)
            }

            // ===== 編集 Overlay =====
            if let idx = editingIndex, items.indices.contains(idx) {
                RenameEditOverlay(
                    original: items[idx].original,
                    text: $editingText,
                    wantsFocus: $wantsFocus,
                    onCommit: { commitEditing() },
                    onCancel: { cancelEditing() }
                )
                .zIndex(10)
            }

            // ===== Key Handling（firstResponder を奪わない方式）=====
            // - 編集中：ここでは何もしない（Enter/Esc は RenameTextEditor 側が取る）
            // - 一覧中：上下/Enter を取る
            KeyEventCatcher { event in
                if editingIndex != nil {
                    // 編集中はエディタに任せる（ここで握ると壊れる）
                    return false
                }
                return handleListKey(event)
            }
            .frame(width: 0, height: 0)
            .allowsHitTesting(false)
            .zIndex(999)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Key Handling (List)

    private func handleListKey(_ event: NSEvent) -> Bool {
        guard !items.isEmpty else { return false }
        guard event.type == .keyDown else { return false }

        switch event.keyCode {
        case 126: // ↑
            moveSelection(delta: -1)
            return true
        case 125: // ↓
            moveSelection(delta: +1)
            return true
        case 36: // Enter
            if let idx = selectedIndex {
                startEditing(index: idx)
                return true
            }
            return false
        default:
            return false
        }
    }

    private func moveSelection(delta: Int) {
        let current = selectedIndex ?? 0
        let next = max(0, min(items.count - 1, current + delta))
        selectedIndex = next
    }

    // MARK: - Editing Control

    private func startEditing(index: Int) {
        guard items.indices.contains(index) else { return }

        selectedIndex = index

        // ✅ 重要：text を先に入れてから overlay を立てる（逆だと空で描画される）
        editingText = items[index].normalized
        editingIndex = index

        // ✅ Overlay 表示直後に Editor にフォーカスを渡す
        wantsFocus = true
    }

    private func commitEditing() {
        guard let idx = editingIndex, items.indices.contains(idx) else {
            resetEditingState()
            return
        }

        items[idx].normalized = editingText

        // 一覧へ戻す（選択は維持）
        selectedIndex = idx

        resetEditingState()
    }

    private func cancelEditing() {
        // 変更破棄
        resetEditingState()
        // selectedIndex はそのまま
    }

    private func resetEditingState() {
        editingIndex = nil
        editingText = ""
        wantsFocus = false
    }

    // MARK: - Folder Load

    private func selectFolderAndLoad() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false

        if panel.runModal() == .OK, let url = panel.url {
            loadFolderNames(from: url)
        }
    }

    private func loadFolderNames(from root: URL) {
        do {
            let urls = try FileManager.default.contentsOfDirectory(
                at: root,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            let newItems: [RenameItem] = urls.compactMap { url -> RenameItem? in
                guard
                    let values = try? url.resourceValues(forKeys: [.isDirectoryKey]),
                    values.isDirectory == true
                else {
                    return nil
                }

                let original = url.lastPathComponent
                let result = NameNormalizer.normalize(original)

                return RenameItem(
                    original: original,
                    normalized: result.normalized
                )
            }

            items = newItems
            selectedIndex = items.isEmpty ? nil : 0

        } catch {
            print("Load error:", error)
        }
    }
}
