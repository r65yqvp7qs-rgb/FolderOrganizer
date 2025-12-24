// Views/Rename/List/RenameListView.swift
import SwiftUI

struct RenameListView: View {

    @StateObject private var session = RenameSession(
        items: FileScanService.loadSampleNames()
    )

    let showSpaceMarkers: Bool

    var body: some View {
        ScrollViewReader { proxy in
            List(selection: $session.selectedID) {

                ForEach(session.items) { item in
                    RenamePreviewRowView(
                        item: item,
                        showSpaceMarkers: showSpaceMarkers,
                        onEdit: {
                            session.selectedID = item.id
                            session.isEditing = true
                        }
                    )
                    .tag(item.id) // ★ List(selection:) とセット
                    // macOS List は background より listRowBackground が安定
                    .listRowBackground(
                        session.selectedID == item.id
                        ? Color.accentColor.opacity(0.15)
                        : Color.clear
                    )
                    .id(item.id) // ★ scrollTo用
                }
            }
            .onChange(of: session.selectedID) { _, newID in
                guard let newID else { return }
                withAnimation {
                    proxy.scrollTo(newID, anchor: .center)
                }
            }
        }
        .sheet(isPresented: $session.isEditing) {
            RenameEditView(
                session: session,
                showSpaceMarkers: showSpaceMarkers
            )
        }
    }
}
