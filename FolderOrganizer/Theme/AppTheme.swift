// FolderOrganizer/App/AppTheme.swift
//
// アプリ全体の色・スタイル定義
// ・Issue 可視化用の色を追加
//

import SwiftUI

enum AppTheme {

    enum colors {

        // 既存色（※他にも定義があればそのまま残す）
        static let primaryText = Color.primary
        static let secondaryText = Color.secondary

        // MARK: - Issue Colors（v0.2）

        /// RenameIssue.warning 用（目立ちすぎない注意色）
        static let issueWarning = Color.yellow.opacity(0.85)

        /// RenameIssue.error 用（明確な警告色）
        static let issueError = Color.red
    }
}
