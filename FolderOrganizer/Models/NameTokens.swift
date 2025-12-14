import Foundation

/// 文字列を「意味づけ前」で分解した結果
struct NameTokens {

    /// [作者名] などから抽出された候補
    let authorCandidates: [String]

    /// タイトル候補
    let titleCandidates: [String]

    /// () や suffix などの生要素
    let rawSubstrings: [String]
}
