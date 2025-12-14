import Foundation

protocol ContextResolutionService {

    /// 現在のURLから文脈を判断
    func resolveContext(for url: URL) -> ContextInfo
}

final class DefaultContextResolutionService: ContextResolutionService {

    func resolveContext(for url: URL) -> ContextInfo {
        let parent = url.deletingLastPathComponent()

        // TODO: 作者フォルダ直下判定
        return ContextInfo(
            currentParent: parent,
            isUnderAuthorFolder: false
        )
    }
}
