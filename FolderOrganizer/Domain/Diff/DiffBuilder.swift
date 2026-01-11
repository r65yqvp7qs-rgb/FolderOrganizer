//
//  Domain/Diff/DiffBuilder.swift
//
//  Myers Diff を使って DiffToken を生成（STEP 3-6）
//  ・insert / delete / equal を生成
//  ・delete+insert を replace として束ねる
//

import Foundation

enum DiffBuilder {

    // アラインメント用の列（1カラムに original と normalized の情報を持たせる）
    private struct DiffColumn {
        var originalChar: Character?
        var originalOp: DiffOperation?

        var normalizedChar: Character?
        var normalizedOp: DiffOperation?
    }

    static func build(
        original: String,
        normalized: String
    ) -> (original: [DiffToken], normalized: [DiffToken]) {

        let oChars = Array(original)
        let nChars = Array(normalized)

        // 1) まずは equal / delete / insert の列を作る
        let ops = MyersDiff.diff(old: oChars, new: nChars)
        var columns: [DiffColumn] = []

        var oIndex = 0
        var nIndex = 0

        for op in ops {
            switch op {
            case .equal:
                columns.append(
                    DiffColumn(
                        originalChar: oChars[oIndex],
                        originalOp: .equal,
                        normalizedChar: nChars[nIndex],
                        normalizedOp: .equal
                    )
                )
                oIndex += 1
                nIndex += 1

            case .delete:
                columns.append(
                    DiffColumn(
                        originalChar: oChars[oIndex],
                        originalOp: .delete,
                        normalizedChar: nil,
                        normalizedOp: nil
                    )
                )
                oIndex += 1

            case .insert:
                columns.append(
                    DiffColumn(
                        originalChar: nil,
                        originalOp: nil,
                        normalizedChar: nChars[nIndex],
                        normalizedOp: .insert
                    )
                )
                nIndex += 1

            case .replace:
                // MyersDiff は replace を返さない設計（ここには来ない）
                break
            }
        }

        // 2) delete-run + insert-run を replace に束ねる（STEP 3-6）
        columns = mergeDeleteInsertToReplace(columns)

        // 3) columns から tokens を復元
        var originalTokens: [DiffToken] = []
        var normalizedTokens: [DiffToken] = []

        for col in columns {
            if let ch = col.originalChar, let op = col.originalOp {
                originalTokens.append(
                    DiffToken(character: String(ch), operation: op)
                )
            }

            if let ch = col.normalizedChar, let op = col.normalizedOp {
                normalizedTokens.append(
                    DiffToken(character: String(ch), operation: op)
                )
            }
        }

        return (originalTokens, normalizedTokens)
    }

    // MARK: - Replace merge

    /// delete の連続 → insert の連続 を検出し、同数分を replace に変換する
    private static func mergeDeleteInsertToReplace(_ input: [DiffColumn]) -> [DiffColumn] {

        var output: [DiffColumn] = []
        var i = 0

        func isDeleteOnly(_ c: DiffColumn) -> Bool {
            c.originalChar != nil && c.originalOp == .delete && c.normalizedChar == nil
        }

        func isInsertOnly(_ c: DiffColumn) -> Bool {
            c.normalizedChar != nil && c.normalizedOp == .insert && c.originalChar == nil
        }

        while i < input.count {

            // delete-run を集める
            if isDeleteOnly(input[i]) {
                var deletes: [DiffColumn] = []
                var j = i
                while j < input.count, isDeleteOnly(input[j]) {
                    deletes.append(input[j])
                    j += 1
                }

                // 直後の insert-run を集める
                var inserts: [DiffColumn] = []
                var k = j
                while k < input.count, isInsertOnly(input[k]) {
                    inserts.append(input[k])
                    k += 1
                }

                // delete-run の直後に insert-run がある場合だけ束ねる
                if !inserts.isEmpty {
                    let pairCount = min(deletes.count, inserts.count)

                    // (a) ペア分を replace 化（同じカタマリとして扱う）
                    for idx in 0..<pairCount {
                        let d = deletes[idx]
                        let ins = inserts[idx]

                        output.append(
                            DiffColumn(
                                originalChar: d.originalChar,
                                originalOp: .replace,
                                normalizedChar: ins.normalizedChar,
                                normalizedOp: .replace
                            )
                        )
                    }

                    // (b) 余った delete は delete のまま
                    if deletes.count > pairCount {
                        for idx in pairCount..<deletes.count {
                            output.append(deletes[idx])
                        }
                    }

                    // (c) 余った insert は insert のまま
                    if inserts.count > pairCount {
                        for idx in pairCount..<inserts.count {
                            output.append(inserts[idx])
                        }
                    }

                    // 次の位置へ
                    i = k
                    continue
                } else {
                    // insert-run が無い → delete-run をそのまま出力
                    output.append(contentsOf: deletes)
                    i = j
                    continue
                }
            }

            // delete-run 開始じゃなければそのまま
            output.append(input[i])
            i += 1
        }

        return output
    }
}
