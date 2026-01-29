// FolderOrganizer/Views/Browse/FolderRowView.swift
//
// フォルダ行表示
// - 1行目: フォルダ名 + roleHint バッジ + ★
// - D-3: roleHint=UNKNOWN の場合、confidence に入っている理由を2行目に表示する（最小差分）
//

import SwiftUI

struct FolderRowView: View {

    let node: FolderNode

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {

            // ===== 1行目：基本情報 =====
            HStack(spacing: 8) {
                Image(systemName: "folder")
                    .foregroundColor(.accentColor)

                Text(node.name)
                    .lineLimit(1)

                Text(node.roleHint.rawValue.uppercased())
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(roleBackground(node.roleHint))
                    .foregroundColor(.white)
                    .cornerRadius(6)

                ConfidenceStarsView(confidence: node.confidence)

                Spacer()

                if node.fileCount > 0 {
                    Text("(\(node.fileCount))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            // --- 2行目: UNKNOWN 理由（D-3） ---
            if case .unknown(let reasons) = node.confidence {
                VStack(alignment: .leading, spacing: 1) {
                    ForEach(reasons, id: \.id) { reason in
                        Text("・\(reason.description)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                .padding(.leading, 22) // folder icon 分だけインデント
                .padding(.top, 2)
            }
        }
        .padding(.vertical, 2)
    }

    // MARK: - Role Color

    private func roleBackground(_ role: FolderRoleHint) -> Color {
        switch role {
        case .series:
            return .blue
        case .volume:
            return .green
        case .unknown:
            return .gray
        }
    }
}
