//
//  Views/Rename/Preview/DiffTextView.swift
//
//  Myers Diff 表示（STEP 3-5 最終調整）
//  ・insert / delete / equal 分離
//  ・未変更スペースをアクセント系カラーで表示
//  ・一覧視認性向上のため文字サイズ拡大
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
        // 👇 Diff 前提で少し大きめ
        .font(.system(size: 15, design: .monospaced))
    }

    // MARK: - Rendering

    private func render(tokens: [DiffToken]) -> Text {
        tokens.reduce(Text("")) { result, token in
            let displayChar = visibleCharacter(token.character)

            let color: Color? = {
                switch token.operation {
                case .delete:
                    return .red

                case .insert:
                    return .green

                case .equal:
                    // 未変更スペースのみ「控えめなアクセント色」
                    if isSpace(token.character) {
                        return Color.accentColor.opacity(0.55)
                    } else {
                        return nil
                    }
                }
            }()

            return result + Text(displayChar).foregroundColor(color)
        }
    }

    // MARK: - Space Handling

    private func isSpace(_ char: String) -> Bool {
        char == " " || char == "　"
    }

    private func visibleCharacter(_ char: String) -> String {
        guard showSpaceMarkers else { return char }

        switch char {
        case " ":
            return "␣"
        case "　":
            return "□"   // 全角スペース
        default:
            return char
        }
    }
}
