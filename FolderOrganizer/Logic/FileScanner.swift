import Foundation
import AppKit

struct FileScanner {

    static func pickFolder() -> URL? {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        return panel.runModal() == .OK ? panel.url : nil
    }

    static func loadFolders(from url: URL) -> [RenameItem] {

        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        return contents.compactMap { item in
            // フォルダ以外は無視
            guard let values = try? item.resourceValues(forKeys: [.isDirectoryKey]),
                  values.isDirectory == true else {
                return nil           // ← compactMap の中なので OK
            }

            let folderName = item.lastPathComponent
            let norm = NameNormalizer.normalize(folderName)

            return RenameItem(
                original: norm.original,
                normalized: norm.displayName,
                flagged: false
            )
        }
    }
}
