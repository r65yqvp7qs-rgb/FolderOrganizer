//  Logic/FileScanService.swift
import Foundation

#if os(macOS)
import AppKit
import UniformTypeIdentifiers
#endif

// 検証用 JSON 1行ぶん
struct NormalizedExportRow: Codable {
    let original: String
    let renamed: String
    let flagged: Bool
}

struct AuthorMoveLog: Codable {
    let originalFolderName: String
    let newAuthorFolderName: String
    let newWorkFolderName: String
}

struct FileScanService {

    // MARK: - 0. サンプルデータ（デバッグ・UI プレビュー用）

    static func loadSampleNames() -> [RenameItem] {
        let samples = [
            "(同人誌) [たつわの里 (タツワイプ)] デリヘル呼んだら元同級生が来た～ポリネシアンセックス編～ (オリジナル)",
            "(同人誌) [たつわの里 (タツワイプ)] デリヘル呼んだら元同級生が来た 2 (オリジナル)",
            "(同人誌) [まかろんシュガー] 童貞大好き女学生ちゃん、絶倫童貞に敗北するーThird Time is Fateー (オリジナル)",
            "[あおやまきいろ。] シスターガーデン 姉の膣内に射精して、妹の膣内にも射精した。",
            "[しゅにち] ガチハメSEX指導 3",
            "(成年コミック) [猫夜] あげちん♂ ～美女たちにSEXしてとせがまれて～ [DL版]",
            "(C100) [い～ぐるらんど (鷹丸)] 一途な彼女が堕ちる瞬間 (オリジナル) [DL版]"
        ]

        return samples.map { name in
            let result = NameNormalizer.normalize(name)

            return RenameItem(
                original: name,
                normalized: result.displayName,
                flagged: result.hasBlockingWarning
            )
        }
    }

    // MARK: - 1. フォルダ選択ダイアログ

    #if os(macOS)
    /// フォルダ選択用の NSOpenPanel
    static func pickFolder(completion: @escaping (URL?) -> Void) {
        let panel = NSOpenPanel()
        panel.title = "フォルダを選択"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        panel.begin { response in
            if response == .OK {
                completion(panel.url)
            } else {
                completion(nil)
            }
        }
    }
    #endif

    // MARK: - 2. 指定フォルダ直下のフォルダ名一覧を取得

    /// 指定フォルダ直下にある「サブフォルダ」の名前だけを返す
    static func loadFolderNames(from rootURL: URL) -> [String] {
        let fm = FileManager.default
        do {
            let contents = try fm.contentsOfDirectory(
                at: rootURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            let onlyFolders = contents.filter { url in
                (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true
            }

            return onlyFolders.map { $0.lastPathComponent }

        } catch {
            print("フォルダ読み込みエラー:", error)
            return []
        }
    }

    // MARK: - 3. normalize 済みの結果を JSON で書き出す（検証用）

    #if os(macOS)
    /// 指定フォルダ直下のサブフォルダ名を normalize して JSON に書き出す
    ///
    /// - rootURL: 対象となる「元フォルダ」(例: Downloads/作品まとめ)
    static func exportNormalizedJSON(from rootURL: URL) {
        let names = loadFolderNames(from: rootURL)

        let rows: [NormalizedExportRow] = names.map { name in
            let result = NameNormalizer.normalize(name)

            return NormalizedExportRow(
                original: name,
                renamed: result.displayName,
                flagged: result.hasBlockingWarning
            )
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        do {
            let data = try encoder.encode(rows)

            let panel = NSSavePanel()
            panel.title = "正規化結果を JSON で書き出し"
            panel.nameFieldStringValue = "FolderOrganizer_Normalized.json"
            panel.allowedContentTypes = [.json]

            if panel.runModal() == .OK, let url = panel.url {
                try data.write(to: url)
                print("JSON exported to:", url.path)
            }

        } catch {
            print("JSON export error:", error)
        }
    }
    #endif

    // MARK: - 4. [作者] フォルダ自動生成＆作品フォルダ移動

    /// ルートフォルダ直下にある
    ///   [作者] 作品名
    /// という形式のフォルダを
    ///
    ///   [作者] /
    ///       作品名
    ///
    /// の形に整理する。
    ///
    /// - Parameters:
    ///   - rootURL: 作品フォルダ群が並んでいるルート
    ///   - dryRun: true の場合は実際には move せず、ログだけ返す
    ///
    /// - Returns: 実際に行った or 行う予定の移動ログ
    static func organizeByAuthor(
        in rootURL: URL,
        dryRun: Bool = false
    ) throws -> [AuthorMoveLog] {

        let fm = FileManager.default

        let contents = try fm.contentsOfDirectory(
            at: rootURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        // 直下のフォルダのみ対象
        let onlyFolders = contents.filter { url in
            (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true
        }

        var logs: [AuthorMoveLog] = []

        for folderURL in onlyFolders {
            let name = folderURL.lastPathComponent

            // "[作者] 作品名" パターンだけを対象にする
            guard let (author, workTitle) = parseAuthorAndTitle(from: name) else {
                continue
            }

            let authorFolderName = "[\(author)]"
            let authorFolderURL = rootURL.appendingPathComponent(authorFolderName, isDirectory: true)

            // ここで初めて「親が [作者] 」になるので、
            // NameNormalizer.stripAuthorPrefixIfInsideAuthorFolder 相当の動きが有効になる

            // 作品フォルダの新しい名前（[作者] プレフィックスを取り除く）
            let newWorkName = workTitle
            let newWorkURL = authorFolderURL.appendingPathComponent(newWorkName, isDirectory: true)

            let log = AuthorMoveLog(
                originalFolderName: name,
                newAuthorFolderName: authorFolderName,
                newWorkFolderName: newWorkName
            )
            logs.append(log)

            if dryRun {
                // シミュレーションモード → 実際には触らない
                continue
            }

            // 作者フォルダがなければ作成
            if !fm.fileExists(atPath: authorFolderURL.path) {
                try fm.createDirectory(at: authorFolderURL, withIntermediateDirectories: false, attributes: nil)
            }

            // すでに同名フォルダがあった場合は「 (2)」等を付けて避難
            let finalWorkURL = avoidCollision(for: newWorkURL, fileManager: fm)

            try fm.moveItem(at: folderURL, to: finalWorkURL)
        }

        return logs
    }

    /// "[作者] 作品名" をパースして (作者, 作品名) を返す
    private static func parseAuthorAndTitle(from name: String) -> (author: String, title: String)? {
        // 例: "[ナポ] しずかすユートピア"
        let pattern = #"^\[([^\]]+)\]\s*(.+)$"#
        guard
            let regex = try? NSRegularExpression(pattern: pattern),
            let match = regex.firstMatch(
                in: name,
                range: NSRange(name.startIndex..<name.endIndex, in: name)
            ),
            match.numberOfRanges >= 3
        else {
            return nil
        }

        let authorRange = match.range(at: 1)
        let titleRange  = match.range(at: 2)

        guard
            let authorSwiftRange = Range(authorRange, in: name),
            let titleSwiftRange  = Range(titleRange,  in: name)
        else {
            return nil
        }

        let author = String(name[authorSwiftRange])
        let title  = String(name[titleSwiftRange])

        return (author, title)
    }

    /// もし targetURL がすでに存在する場合は " (2)" 等を付けて衝突を避ける
    private static func avoidCollision(for targetURL: URL, fileManager: FileManager) -> URL {
        if !fileManager.fileExists(atPath: targetURL.path) {
            return targetURL
        }

        let baseName = targetURL.deletingPathExtension().lastPathComponent
        let ext = targetURL.pathExtension
        let parent = targetURL.deletingLastPathComponent()

        var counter = 2
        while true {
            let newName: String
            if ext.isEmpty {
                newName = "\(baseName) (\(counter))"
            } else {
                newName = "\(baseName) (\(counter))"
            }
            let candidate = parent.appendingPathComponent(newName, isDirectory: true)
            if !fileManager.fileExists(atPath: candidate.path) {
                return candidate
            }
            counter += 1
        }
    }
}
