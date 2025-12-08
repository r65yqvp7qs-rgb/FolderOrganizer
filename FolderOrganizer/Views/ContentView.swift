//  Views/ContentView.swift
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {

    // 一覧データ
    @State private var items: [RenameItem] = []
    @State private var selectedIndex: Int? = nil

    // 詳細ポップアップ
    @State private var showingDetail = false

    // 編集ポップアップ
    @State private var showingEdit = false
    @State private var editText: String = ""   // 編集用テキスト

    // MARK: - Body

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("FolderOrganizer")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppTheme.colors.titleText)

                HStack(spacing: 16) {
                    Button("フォルダを読み込む") {
                        selectFolderAndLoad()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("JSONを書き出す") {
                        exportJSON()
                    }
                    .buttonStyle(.bordered)
                    .disabled(items.isEmpty)
                }

                if items.isEmpty {
                    Spacer()
                } else {
                    listView
                }
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.colors.background)

        // ==== 詳細ポップアップ ====
        .sheet(isPresented: $showingDetail) {
            if let idx = selectedIndex, items.indices.contains(idx) {
                RenameDetailView(
                    item: items[idx],
                    index: idx,
                    total: items.count,
                    onPrev: { moveSelection(delta: -1) },
                    onNext: { moveSelection(delta: +1) },
                    onClose: { showingDetail = false },
                    onEdit: {
                        // ★ ここがポイント：必ず selectedIndex を見直す
                        guard let current = selectedIndex,
                              items.indices.contains(current) else { return }

                        let item = items[current]
                        editText = initialEditText(for: item)

                        showingDetail = false
                        DispatchQueue.main.async {
                            showingEdit = true
                        }
                    }
                )
            }
        }

        // ==== 編集ポップアップ ====
        .sheet(isPresented: $showingEdit) {
            RenameEditView(
                editText: $editText,
                onCommit: { newText in
                    if let idx = selectedIndex,
                       items.indices.contains(idx) {
                        items[idx].normalized = newText
                    }
                    showingEdit = false
                    showingDetail = true      // 編集後は同じ項目の詳細に戻る
                },
                onCancel: {
                    showingEdit = false
                    showingDetail = true      // キャンセルでも元の詳細に戻る
                }
            )
        }
    }

    private var listView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]
                        let isSelected = (selectedIndex == index)

                        RenamePreviewRow(
                            item: item,
                            index: index,
                            flagged: bindingForFlag(at: index),
                            isSelected: isSelected
                        )
                        .id(index)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedIndex = index
                            showingDetail = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .focusable(true)
            .onKeyDown { event in
                handleKey(event, proxy: proxy)
            }
            // ★ selectedIndex が変わるたびに中央へ（詳細表示中も効く）
            .onChange(of: selectedIndex) { _, newValue in
                if let idx = newValue {
                    scrollToCenter(proxy, idx)
                }
            }
            .onAppear {
                if let idx = selectedIndex {
                    scrollToCenter(proxy, idx)
                }
            }
        }
    }

    // フラグ用 Binding を安全に取り出すヘルパ
    private func bindingForFlag(at index: Int) -> Binding<Bool> {
        Binding(
            get: {
                guard items.indices.contains(index) else { return false }
                return items[index].flagged
            },
            set: { newValue in
                guard items.indices.contains(index) else { return }
                items[index].flagged = newValue
            }
        )
    }

    // MARK: - キー操作（一覧）

    private func handleKey(_ event: NSEvent, proxy: ScrollViewProxy) {
        // 詳細 or 編集を表示している間は一覧のキー操作は無効
        if showingDetail || showingEdit {
            return
        }

        guard !items.isEmpty else { return }

        let current = selectedIndex ?? 0
        var newIndex = current

        switch event.keyCode {
        case 126: // ↑
            newIndex = max(current - 1, 0)

        case 125: // ↓
            newIndex = min(current + 1, items.count - 1)

        case 36, 76: // Enter / Return
            selectedIndex = current
            openDetail()
            return

        default:
            return
        }

        if newIndex != current {
            selectedIndex = newIndex
            withAnimation {
                proxy.scrollTo(newIndex, anchor: .center)
            }
        }
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
        showingEdit = false
        showingDetail = true
    }

    // MARK: - フォルダ読み込み

    private func selectFolderAndLoad() {
        FileScanService.pickFolder { url in
            guard let url = url else { return }

            let names = FileScanService.loadFolderNames(from: url)

            let normalizedItems: [RenameItem] = names.map { name in
                let normalized = NameNormalizer.normalize(name)
                return RenameItem(
                    original: name,
                    normalized: normalized,
                    flagged: false
                )
            }

            DispatchQueue.main.async {
                self.items = normalizedItems
                self.selectedIndex = items.isEmpty ? nil : 0
            }
        }
    }

    // MARK: - JSON 書き出し

    private func exportJSON() {
        #if os(macOS)
        let panel = NSSavePanel()
        panel.title = "JSONを書き出す"
        panel.nameFieldStringValue = "FolderOrganizer.json"
        panel.allowedContentTypes = [.json]

        if panel.runModal() == .OK, let url = panel.url {
            let rows = items.map { item in
                RenameExportRow(
                    original: item.original,
                    renamed: item.normalized,
                    flagged: item.flagged
                )
            }

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

            do {
                let data = try encoder.encode(rows)
                try data.write(to: url)
                print("JSON exported to:", url.path)
            } catch {
                print("JSON export error:", error)
            }
        }
        #endif
    }

    // MARK: - 編集用ヘルパー

    /// 「初回だけ旧／2回目以降は新」を判定して返す
    private func initialEditText(for item: RenameItem) -> String {
        let autoNormalized = NameNormalizer.normalize(item.original)

        if item.normalized == autoNormalized {
            // まだ自動正規化のまま → 旧から編集開始
            return item.original
        } else {
            // 一度以上編集済み → 直近の新から編集
            return item.normalized
        }
    }

    // スクロール中央寄せ関数
    private func scrollToCenter(_ proxy: ScrollViewProxy, _ index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            withAnimation {
                proxy.scrollTo(index, anchor: .center)
            }
        }
    }
}

// JSON出力用
struct RenameExportRow: Codable {
    let original: String
    let renamed: String
    let flagged: Bool
}
