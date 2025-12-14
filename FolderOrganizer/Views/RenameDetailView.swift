// Views/RenameDetailView.swift
import SwiftUI

struct RenameDetailView: View {

    let item: RenameItem
    let index: Int
    let total: Int

    let onPrev: () -> Void
    let onNext: () -> Void
    let onClose: () -> Void
    let onEdit: () -> Void

    @FocusState private var focused: Bool

    /// 右端ボタンレーンの幅
    private let sideButtonWidth: CGFloat = 48

    var body: some View {
        ZStack(alignment: .topTrailing) {

            // ─────────────────────────
            // メインコンテンツ
            // ─────────────────────────
            VStack(spacing: 0) {

                // Header（編集のみ）
                HStack {
                    Button(action: onEdit) {
                        Label("編集", systemImage: "pencil")
                            .font(.headline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)

                // 本文（中央寄せ）
                VStack(alignment: .leading, spacing: 22) {

                    GroupBox("元の名前") {
                        spaceMarkedText(item.original, isNew: false)
                            .frame(minHeight: lineHeight * 2, alignment: .topLeading)
                    }

                    GroupBox("正規化後（新しい名前）") {
                        spaceMarkedText(item.normalized, isNew: true)
                            .frame(minHeight: lineHeight * 2, alignment: .topLeading)
                    }

                    // 現在位置（正規化後の直下・中央）
                    Text("\(index + 1) / \(total)")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 6)
                }
                .padding(.horizontal, 24)
                .padding(.top, 48)
                .padding(.trailing, sideButtonWidth + 16) // ← 右側を確実に空ける
                .padding(.bottom, 24)

                Spacer(minLength: 0)
            }

            // ─────────────────────────
            // 右端 縦ボタンレーン
            // ─────────────────────────
            VStack(spacing: 18) {

                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 26, height: 26)
                }

                Button(action: onPrev) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 26, height: 26)
                }

                Button(action: onNext) {
                    Image(systemName: "arrow.down.circle.fill")
                        .resizable()
                        .frame(width: 26, height: 26)
                }

                Spacer()
            }
            .padding(.top, 14)
            .padding(.trailing, 14)
        }
        .frame(minWidth: 760, minHeight: 460)
        .background(detailBackground)

        // Keyboard
        .focusable(true)
        .focused($focused)
        .onAppear { focused = true }

        .onMoveCommand { dir in
            if dir == .up { onPrev() }
            if dir == .down { onNext() }
        }
        .onKeyPress(.return) {
            onEdit()
            return .handled
        }
        .onKeyPress(.escape) {
            onClose()
            return .handled
        }
    }

    private let lineHeight: CGFloat = 26

    private var detailBackground: Color {
        if TextClassifier.isSubtitle(item.normalized) {
            return AppTheme.colors.subtitleBackground
        }
        if TextClassifier.isPotentialSubtitle(item.normalized) {
            return AppTheme.colors.potentialSubtitleBackground
        }
        return AppTheme.colors.cardBackground
    }

    private func spaceMarkedText(_ text: String, isNew: Bool) -> some View {
        Text(makeAttributedString(text))
            .font(.system(size: 18, design: .monospaced))
            .foregroundColor(isNew ? AppTheme.colors.newText : AppTheme.colors.oldText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .textSelection(.enabled)
    }

    private func makeAttributedString(_ text: String) -> AttributedString {
        var result = AttributedString()
        for ch in text {
            if ch == " " {
                var a = AttributedString("␣")
                a.foregroundColor = AppTheme.colors.spaceMarkerHalf
                result.append(a)
            } else if ch == "　" {
                var a = AttributedString("▢")
                a.foregroundColor = AppTheme.colors.spaceMarkerFull
                result.append(a)
            } else {
                result.append(AttributedString(String(ch)))
            }
        }
        return result
    }
}
