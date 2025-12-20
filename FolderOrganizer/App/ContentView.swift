// App/ContentView.swift
import SwiftUI

struct ContentView: View {

    // サンプル（実アプリでは読み込み結果で置き換え）
    @State private var items: [RenameItem] = []
    @State private var selectedIndex: Int? = nil

    // 編集モーダル
    @State private var isEditing: Bool = false
    @State private var editingText: String = ""

    // ★ スペース可視化 ON/OFF
    @State private var showSpaceMarkers: Bool = true

    var body: some View {
        ZStack {
            VStack(spacing: 12) {

                Text("Folder Organizer")
                    .font(.system(size: 34, weight: .bold))
                    .padding(.top, 16)

                Button("フォルダ名を読み込んで変換プレビュー") {
                    // 仮：いまはダミーを入れる（あなたの実装に合わせて置き換えてOK）
                    loadDummy()
                }
                .buttonStyle(.borderedProminent)

                // ★ スペース可視化トグル
                HStack {
                    Spacer()
                    Toggle("スペース可視化", isOn: $showSpaceMarkers)
                        .toggleStyle(.switch)
                    Spacer()
                }
                .padding(.top, 6)

                // 一覧
                RenamePreviewList(
                    items: $items,
                    selectedIndex: $selectedIndex,
                    showSpaceMarkers: showSpaceMarkers,
                    onSelect: { index in
                        selectedIndex = index
                        editingText = items[index].displayNameForList
                        isEditing = true
                    }
                )
                .padding(.top, 8)

                Spacer()
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.92)) // 好みで AppTheme.colors.background へ置き換えてOK
            .foregroundStyle(.white)

            // ─────────────────────────
            // 編集モーダル（背景を透かさない：二重に見える問題を潰す）
            // ─────────────────────────
            if isEditing, let index = selectedIndex {
                // 背面を暗くする（タップで閉じる）
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
                    .onTapGesture { closeEditor() }

                RenameEditView(
                    original: items[index].original,
                    edited: $editingText,
                    showSpaceMarkers: showSpaceMarkers,
                    onCommit: {
                        items[index].edited = editingText
                        closeEditor()
                    },
                    onCancel: {
                        closeEditor()
                    }
                )
                .background(AppTheme.colors.cardBackground) // ←ここが「オレンジ」じゃない最終背景
                .cornerRadius(14)
                .shadow(radius: 24)
                .padding()
            }
        }
        .onAppear {
            // 初回表示用（必要なければ消してOK）
            if items.isEmpty { loadDummy() }
        }
    }

    // MARK: - Helpers

    private func closeEditor() {
        isEditing = false
        selectedIndex = nil
        editingText = ""
    }

    private func loadDummy() {
        // RenameItem の実体に合わせて調整してOK
        items = [
            RenameItem(original: "[diletta] 愛獣に飢えた渋谷令嬢をメス堕ちさせるまで飼いならし、堕る。",
                      normalized: "[diletta] 愛獣に飢えた渋谷令嬢をメス堕ちさせるまで飼いならし、堕る。",
                      flagged: false),
        ]
    }
}
