import Foundation

protocol NameNormalizationService {

    /// 表記揺れを正すだけ（意味判断なし）
    func normalize(_ rawName: String) -> String
}

/// 仮実装（後で差し替え）
final class DefaultNameNormalizationService: NameNormalizationService {

    func normalize(_ rawName: String) -> String {
        // TODO: 全角→半角、空白正規化など
        return rawName
    }
}
