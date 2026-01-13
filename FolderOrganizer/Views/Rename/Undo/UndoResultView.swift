//
//  Views/Rename/Undo/UndoResultView.swift
//  FolderOrganizer
//
//  Undo 実行結果を表示する View
//

import SwiftUI

struct UndoResultView: View {

    let undoResults: [UndoResult]
    let rollbackInfo: RollbackInfo
    let onClose: () -> Void

    // MARK: - Derived

    /// 成功した Undo の index 一覧
    private var successIndexes: [Int] {
        undoResults.enumerated().compactMap { index, result in
            if case .success = result {
                return index
            }
            return nil
        }
    }

    /// 失敗した Undo（index + error）
    private var failureErrors: [(Int, Error)] {
        undoResults.enumerated().compactMap { (index, result) -> (Int, Error)? in
            if case .failure(_, let error) = result {
                return (index, error)
            }
            return nil
        }
    }

    private var successCount: Int { successIndexes.count }
    private var failureCount: Int { failureErrors.count }

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Undo 結果")
                .font(.headline)

            Text("成功: \(successCount) 件 / 失敗: \(failureCount) 件")
                .font(.subheadline)

            Divider()

            List {
                ForEach(Array(undoResults.enumerated()), id: \.offset) { index, result in
                    rowView(for: index, result: result)
                }
            }

            HStack {
                Spacer()
                Button("閉じる") {
                    onClose()
                }
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 400)
    }

    // MARK: - Row

    @ViewBuilder
    private func rowView(for index: Int, result: UndoResult) -> some View {
        switch result {

        case .success(let move):
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text(move.to.lastPathComponent)
                Spacer()
            }

        case .failure(let move, let error):
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text(move.to.lastPathComponent)
                    Spacer()
                }

                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading, 22)
            }
        }
    }
}
