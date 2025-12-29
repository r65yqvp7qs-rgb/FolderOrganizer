// App/ContentView.swift
import SwiftUI

/// アプリのルート View
struct ContentView: View {

    @StateObject private var session = RenameSession(
        items: [
            RenameItem(original: "01_test.txt", normalized: "01_test.txt"),
            RenameItem(original: "02_sample.txt", normalized: "02_sample.txt", flagged: true),
            RenameItem(original: "03_demo.txt", normalized: "03_demo.txt")
        ]
    )

    var body: some View {
        RenamePreviewListView(session: session)
            .frame(minWidth: 480, minHeight: 360)
    }
}
