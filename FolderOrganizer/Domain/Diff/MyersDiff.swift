//
//  Domain/Diff/MyersDiff.swift
//
//  Myers Diff（文字単位・簡易実装）
//  ・最小 edit script を生成
//  ・性能より可読性優先
//

import Foundation

enum MyersDiff {

    static func diff(old: [Character], new: [Character]) -> [DiffOperation] {
        let n = old.count
        let m = new.count

        var dp = Array(
            repeating: Array(repeating: 0, count: m + 1),
            count: n + 1
        )

        for i in 0..<n {
            for j in 0..<m {
                if old[i] == new[j] {
                    dp[i + 1][j + 1] = dp[i][j] + 1
                } else {
                    dp[i + 1][j + 1] = max(dp[i][j + 1], dp[i + 1][j])
                }
            }
        }

        var ops: [DiffOperation] = []
        var i = n
        var j = m

        while i > 0 || j > 0 {
            if i > 0, j > 0, old[i - 1] == new[j - 1] {
                ops.append(.equal)
                i -= 1
                j -= 1
            } else if j > 0, (i == 0 || dp[i][j - 1] >= dp[i - 1][j]) {
                ops.append(.insert)
                j -= 1
            } else {
                ops.append(.delete)
                i -= 1
            }
        }

        return ops.reversed()
    }
}
