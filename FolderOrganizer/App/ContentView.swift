// Views/ContentView.swift
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var items: [RenameItem] = []
    @State private var selectedIndex: Int? = nil
    @State private var showingDetail = false

    var body: some View {
        ZStack {
            VStack(spacing: 18) {
                Text("Folder Organizer")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 18)

                Button {
                    // ここは既存の読み込み処理に接続してOK
                    loadSample()
                } label: {
                    Text("フォルダ名を読み込んで変換プレビュー")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 28)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)

                RenamePreviewList(items: $items, selectedIndex: $selectedIndex)

                Spacer(minLength: 8)
            }
            .padding(.bottom, 18)

            // 詳細ポップアップ
            if showingDetail, let idx = selectedIndex, items.indices.contains(idx) {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture { showingDetail = false }

                RenameDetailView(
                    original: items[idx].original,
                    suggested: items[idx].normalized,
                    editedText: $items[idx].edited,
                    onResetToSuggested: {
                        items[idx] = items[idx].resetEditedName()
                    },
                    onClose: {
                        showingDetail = false
                    }
                )
                .frame(width: 760, height: 420)
                .background(Color.orange.opacity(0.95))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 18)
                .onKeyDown(perform: { event in
                    // 詳細表示中のキー（Escで閉じる）
                    if event.keyCode == 53 { // Esc
                        showingDetail = false
                    }
                })
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .openDetailFromList)) { _ in
            openDetail()
        }
        .onKeyDown(perform: { event in
            // 一覧のキー操作（↑↓ Enter Esc）
            switch event.keyCode {
            case 126: // ↑
                moveSelection(delta: -1)
            case 125: // ↓
                moveSelection(delta: 1)
            case 36: // Return
                openDetail()
            case 53: // Esc
                showingDetail = false
            default:
                break
            }
        })
    }

    // MARK: - Actions

    private func loadSample() {
        let samples = [
            "【同人誌】【黒山羊×工玉】元カレのデカチンが忘れられないの？（オリジナル）【DL版】",
            "【diletta】愛獣に飢えた渋谷令嬢をメス堕ちさせるまで飼いならし、堕ろ。",
            "【立花ナミ】異世界ハーレム物語 vol.2.5",
            "【あいさわひろり】",
            "【成年コミック】【猫夜】あげちん♂〜美女たちにSEXしてとせがまれて〜【DL版】"
        ]

        items = samples.map { name in
            let result = NameNormalizer.normalize(name)
            return RenameItem(
                original: name,
                normalized: result.normalizedName,
                edited: "",
                flagged: false
            )
        }

        selectedIndex = items.isEmpty ? nil : 0
    }

    private func moveSelection(delta: Int) {
        guard !items.isEmpty else { return }
        let current = selectedIndex ?? 0
        var next = current + delta
        next = max(0, min(items.count - 1, next))
        selectedIndex = next
    }

    private func openDetail() {
        guard !items.isEmpty else { return }
        if selectedIndex == nil { selectedIndex = 0 }
        showingDetail = true
    }
}
