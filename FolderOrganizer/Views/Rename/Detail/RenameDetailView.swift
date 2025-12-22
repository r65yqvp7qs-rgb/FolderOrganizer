// Views/Rename/RenameDetailView.swift

import SwiftUI

struct RenameDetailView: View {

    let items: [RenameItem]
    let initialIndex: Int

    @State private var selectedIndex: Int

    init(items: [RenameItem], initialIndex: Int) {
        self.items = items
        self.initialIndex = initialIndex
        _selectedIndex = State(initialValue: initialIndex)
    }

    var body: some View {
        VStack {
            header

            List {
                ForEach(items.indices, id: \.self) { index in
                    row(for: index)
                }
            }
            .listStyle(.plain)
        }
        .frame(minWidth: 520, minHeight: 420)
    }

    private var header: some View {
        HStack {
            Button("↑") { moveSelection(-1) }
            Button("↓") { moveSelection(1) }

            Spacer()

            Text("\(selectedIndex + 1) / \(items.count)")
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private func row(for index: Int) -> some View {
        let item = items[index]

        return HStack {
            Text(item.original)
                .lineLimit(1)
            Spacer()
        }
        .contentShape(Rectangle())
        .background(
            index == selectedIndex
                ? Color.accentColor.opacity(0.15)
                : Color.clear
        )
        .onTapGesture {
            selectedIndex = index
        }
    }

    private func moveSelection(_ delta: Int) {
        let next = selectedIndex + delta
        guard items.indices.contains(next) else { return }
        selectedIndex = next
    }
}
