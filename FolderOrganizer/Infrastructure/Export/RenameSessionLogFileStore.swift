// FolderOrganizer/Infrastructure/Export/RenameSessionLogFileStore.swift
//
// RenameSessionLog を JSON としてファイル保存する低レイヤ。
// - 保存先：Application Support/FolderOrganizer/Logs/
// - ファイル名：<timestamp>_<sessionID>.json
// - v0.2 は「自動保存のみ」なので、ここが安定稼働すれば勝ち
//

import Foundation

final class RenameSessionLogFileStore {

    // MARK: - Dependencies

    private let fileManager: FileManager

    // MARK: - Init

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    // MARK: - Public

    func save(_ log: RenameSessionLog) {
        do {
            let directoryURL = try ensureLogDirectory()
            let fileURL = directoryURL.appendingPathComponent(makeFileName(for: log))

            let data = try encode(log)
            try writeAtomically(data, to: fileURL)
        } catch {
            // v0.2: 自動保存の失敗でアプリを止めない（ログ保存は「補助機能」）
            // 将来：ここを OSLog や ExportFailureLog にしても良い。
            #if DEBUG
            print("❌ RenameSessionLog save failed: \(error)")
            #endif
        }
    }

    // MARK: - Directory

    private func ensureLogDirectory() throws -> URL {
        let appSupport = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        let dir = appSupport
            .appendingPathComponent("FolderOrganizer", isDirectory: true)
            .appendingPathComponent("Logs", isDirectory: true)

        if !fileManager.fileExists(atPath: dir.path) {
            try fileManager.createDirectory(
                at: dir,
                withIntermediateDirectories: true
            )
        }

        return dir
    }

    // MARK: - Encode

    private func encode(_ log: RenameSessionLog) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        // Date は人間にも読みやすい ISO-8601 に固定
        if #available(macOS 12.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        } else {
            let formatter = ISO8601DateFormatter()
            encoder.dateEncodingStrategy = .custom { date, encoder in
                var container = encoder.singleValueContainer()
                try container.encode(formatter.string(from: date))
            }
        }

        return try encoder.encode(log)
    }

    // MARK: - FileName

    private func makeFileName(for log: RenameSessionLog) -> String {
        let stamp = Self.fileNameStamp(from: log.createdAt)
        return "\(stamp)_\(log.id.uuidString).json"
    }

    private static func fileNameStamp(from date: Date) -> String {
        // ファイル名向け：記号を避けてソートしやすい形式にする
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter.string(from: date)
    }

    // MARK: - Atomic Write

    private func writeAtomically(_ data: Data, to url: URL) throws {
        // atomic: 書き込み中に落ちても壊れたファイルが残りにくい
        try data.write(to: url, options: [.atomic])
    }
}
