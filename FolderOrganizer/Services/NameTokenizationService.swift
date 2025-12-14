import Foundation

protocol NameTokenizationService {

    /// 正規化済み文字列を機械的に分解
    func tokenize(_ normalizedName: String) -> NameTokens
}

final class DefaultNameTokenizationService: NameTokenizationService {

    func tokenize(_ normalizedName: String) -> NameTokens {
        // TODO: [] () 区切り解析
        return NameTokens(
            authorCandidates: [],
            titleCandidates: [normalizedName],
            rawSubstrings: []
        )
    }
}
