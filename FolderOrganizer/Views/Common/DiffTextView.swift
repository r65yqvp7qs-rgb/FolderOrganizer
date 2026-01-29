// FolderOrganizer/Views/Common/DiffTextView.swift
//
// original と final（変更後）を比較表示する View
// ・DiffBuilder を使って差分を可視化
//

import SwiftUI

struct DiffTextView: View {

    let original: String
    let final: String
    let showSpaceMarkers: Bool

    var body: some View {
        let tokens = DiffBuilder.build(
            original: original,
            modified: final
        )

        VStack(alignment: .leading, spacing: 2) {
            DiffLineView(tokens: tokens.original, showSpaceMarkers: showSpaceMarkers)
            DiffLineView(tokens: tokens.modified, showSpaceMarkers: showSpaceMarkers)
        }
        .font(.system(size: 13, design: .monospaced))
    }
}
