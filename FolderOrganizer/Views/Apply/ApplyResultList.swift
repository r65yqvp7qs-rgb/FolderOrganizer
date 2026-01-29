// FolderOrganizer/Views/Apply/ApplyResultList.swift
//
// Apply 結果の簡易リスト表示。
// - v0.2 では「自動保存ログ」が主目的なので、UI は最小構成
// - Undo UI は未導入のため、RollbackInfo は「件数表示」のみ
//

import SwiftUI

struct ApplyResultList: View {

    let results: [ApplyResult]
    let rollbackInfo: RollbackInfo?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            if results.isEmpty {
                Text("結果がありません。")
                    .foregroundColor(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(results.enumerated()), id: \.offset) { index, result in
                        ApplyResultRowView(
                            index: index + 1,
                            result: result
                        )
                    }
                }
            }

            if let rollbackInfo {
                Divider()
                Text("Undo 用 move 件数: \(rollbackInfo.moves.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

private struct ApplyResultRowView: View {

    let index: Int
    let result: ApplyResult

    var body: some View {
        HStack(spacing: 10) {

            Image(systemName: iconName)
                .frame(width: 16)

            Text("Result \(index)")
                .font(.subheadline)

            Spacer()

            Text(statusText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }

    private var iconName: String {
        switch result.status {
        case .success:
            return "checkmark.circle.fill"
        case .skipped:
            return "minus.circle"
        case .failure:
            return "xmark.octagon.fill"
        }
    }

    private var statusText: String {
        switch result.status {
        case .success:
            return "success"
        case .skipped(let reason):
            return "skipped: \(reason)"
        case .failure(let error):
            return "failure: \(error.errorDescription ?? "")"
        }
    }
}
