//
// Logic/FileScanService.swift
//
import Foundation

/// フォルダスキャン結果のダミーデータ生成用サービス
/// - UIプレビュー / 開発中の確認用途
struct FileScanService {

    /// デバッグ・プレビュー用の仮データ
    static func loadSampleNames() -> [RenameItem] {

        let samples: [String] = [
            "【同人誌】【黒山羊×玉】元カレのテクが忘れられない？（オリジナル）[DL版]",
            "[diletta] 異世界で治癒魔法を使いこなして鍛えなおし、堕る。",
            "【立花ナツ】 異世界ハーレム物語 vol.2.5",
            "【あいざわひろ】",
            "【成年コミック】【猫夜】 あげちん〜美女たちにSEXしてとせがまれて〜 [DL版]"
        ]

        return samples.map { name in
            let normalized = NameNormalizer.normalize(name)

            return RenameItem(
                id: UUID(),
                original: name,
                normalized: normalized,
                flagged: false
            )
        }
    }
}
