// Views/Rename/Edit/RenameEditView.swift
import SwiftUI

/// 編集中オーバーレイ（STEP C：ダミー）
struct RenameEditView: View {

    @ObservedObject var session: RenameSession

    var body: some View {
        VStack {
            Spacer()

            Text("Editing...")
                .font(.headline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.25))
    }
}
