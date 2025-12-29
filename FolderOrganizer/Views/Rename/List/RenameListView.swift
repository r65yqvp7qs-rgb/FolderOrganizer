import SwiftUI

struct RenameListView: View {

    @ObservedObject var session: RenameSession

    var body: some View {
        List {
            ForEach(session.items) { item in
                Text(item.original)
            }
        }
        .listStyle(.plain)
    }
}
