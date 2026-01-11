//
//  Views/Rename/Preview/DiffTextView.swift
//
//  original / normalized を Diff 表示
//  ・文字単位 Diff（STEP 3-4）
//  ・スペース可視化対応
//

import SwiftUI

struct DiffTextView: View {

    let original: String
    let normalized: String
    let showSpaceMarkers: Bool

    private var diffResult: (original: [DiffToken], normalized: [DiffToken]) {
        DiffBuilder.build(
            original: original,
            normalized: normalized
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {

            render(tokens: diffResult.original)
                .foregroundStyle(AppTheme.colors.secondaryText)

            render(tokens: diffResult.normalized)
                .foregroundStyle(.primary)
        }
        .font(.system(size: 13, design: .monospaced))
    }

    // MARK: - Rendering

    private func render(tokens: [DiffToken]) -> Text {
        tokens.reduce(Text("")) { result, token in
            let displayChar = visibleCharacter(token.character)

            let text = Text(displayChar)
                .foregroundColor(token.isChanged ? .red : nil)

            return result + text
        }
    }

    // MARK: - Space Visualization

    private func visibleCharacter(_ char: String) -> String {
        guard showSpaceMarkers else { return char }

        switch char {
        case " ":
            return "␣"
        case "　":
            return "␣␣"
        default:
            return char
        }
    }
}
