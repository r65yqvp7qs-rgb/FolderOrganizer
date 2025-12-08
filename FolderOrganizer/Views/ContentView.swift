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
    @State private var editBuffer: String = ""   // 下段：編集中テキスト

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

        // MARK: 詳細ポップアップ
        .sheet(isPresented: $showingDetail) {
            if let idx = selectedIndex {
                RenameDetailView(
                    item: items[idx],
                    index: idx,
                    total: items.count,
                    onPrev: { moveSelection(delta: -1) },
                    onNext: { moveSelection(delta: +1) },
                    onClose: {
                        showingDetail = false
                    },
                    onEdit: {
                        let item = items[idx]

                        // 下段の初期値：
                        // まだ自動正規化のまま => 旧から編集開始
                        // すでにユーザー編集済み => 直近の新から編集開始
                        editBuffer = initialEditText(for: item)

                        showingDetail = false
                        DispatchQueue.main.async {
                            showingEdit = true
                        }
                    }
                )
            }
        }

        // MARK: 編集ポップアップ
        .sheet(isPresented: $showingEdit) {
            RenameEditView(
                editText: $editBuffer,
                onCommit: { newText in
                    if let idx = selectedIndex {
                        items[idx].normalized = newText   // 新に保存
                    }
                    showingEdit = false
                    showingDetail = true
                },
                onCancel: {
                    showingEdit = false
                    showingDetail = true
                }
            )
        }
    }

    // MARK: - LIST VIEW

    private var listView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    let allIndices = items.indices

                    ForEach(allIndices, id: \.self) { index in
                        let item = items[index]
                        let isOdd = index.isMultiple(of: 2)
                        let isSelected = (selectedIndex == index)

                        RenamePreviewRow(
                            original: item.original,
                            normalized: item.normalized,
                            isOdd: isOdd,
                            isSelected: isSelected,
                            flagged: $items[index].flagged
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
        }
    }

    // MARK: - キー操作（一覧）

    private func handleKey(_ event: NSEvent, proxy: ScrollViewProxy) {
        if showingDetail || showingEdit { return }
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

    /// 「初回だけ旧／2回目以降は新」の判定
    private func initialEditText(for item: RenameItem) -> String {
        let autoNormalized = NameNormalizer.normalize(item.original)

        if item.normalized == autoNormalized {
            // まだ自動正規化のまま → 旧から編集開始
            return item.original
        } else {
            // すでに一度以上編集済み → 直近の新から編集
            return item.normalized
        }
    }
}

// JSON出力用
struct RenameExportRow: Codable {
    let original: String
    let renamed: String
    let flagged: Bool
}
