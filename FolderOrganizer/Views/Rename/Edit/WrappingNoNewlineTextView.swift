// FolderOrganizer/Views/Rename/Edit/WrappingNoNewlineTextView.swift
//
// NSTextView ラッパー（改行不可・折り返しあり）
// - Enter: 確定（改行は入れない）
// - Esc: キャンセル
// - 貼り付け等で改行が混ざった場合はスペースに置換して 1 行化
// - 折り返しは textContainer.widthTracksTextView = true で実現
//

import SwiftUI
import AppKit

struct WrappingNoNewlineTextView: NSViewRepresentable {

    // MARK: - Bindings

    @Binding var text: String
    @Binding var isFocused: Bool

    // MARK: - Callbacks

    let onCommit: () -> Void
    let onCancel: () -> Void

    // MARK: - NSViewRepresentable

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false
        scrollView.borderType = .noBorder

        let textView = NoNewlineTextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.isRichText = false
        textView.importsGraphics = false
        textView.drawsBackground = false

        // 見やすい大きめ（一覧より大きめを意図）
        textView.font = NSFont.systemFont(ofSize: 22, weight: .semibold)
        textView.textContainerInset = NSSize(width: 10, height: 10)

        // 折り返し
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width]

        if let tc = textView.textContainer {
            tc.widthTracksTextView = true
            tc.heightTracksTextView = false
            tc.lineFragmentPadding = 0
            tc.containerSize = NSSize(width: scrollView.contentSize.width, height: .greatestFiniteMagnitude)
        }

        textView.string = text
        textView.onCommit = onCommit
        textView.onCancel = onCancel

        scrollView.documentView = textView
        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }

        // 外部反映
        if textView.string != text {
            textView.string = text
        }

        // フォーカス
        if isFocused, let window = nsView.window, window.firstResponder !== textView {
            DispatchQueue.main.async {
                window.makeFirstResponder(textView)
                textView.selectAll(nil)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, NSTextViewDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textDidChange(_ notification: Notification) {
            guard let tv = notification.object as? NSTextView else { return }
            text = tv.string
        }

        /// 改行禁止（貼り付け含む）
        func textView(_ textView: NSTextView,
                      shouldChangeTextIn affectedCharRange: NSRange,
                      replacementString: String?) -> Bool {

            guard let replacement = replacementString else { return true }

            if replacement.contains("\n") || replacement.contains("\r") {
                let singleLine = replacement
                    .replacingOccurrences(of: "\r\n", with: " ")
                    .replacingOccurrences(of: "\n", with: " ")
                    .replacingOccurrences(of: "\r", with: " ")

                textView.textStorage?.replaceCharacters(in: affectedCharRange, with: singleLine)
                text = textView.string
                return false
            }

            return true
        }
    }

    // MARK: - NSTextView subclass

    final class NoNewlineTextView: NSTextView {
        var onCommit: (() -> Void)?
        var onCancel: (() -> Void)?

        override func insertNewline(_ sender: Any?) {
            // Enter = 確定
            onCommit?()
        }

        override func cancelOperation(_ sender: Any?) {
            // Esc = キャンセル
            onCancel?()
        }

        override func doCommand(by selector: Selector) {
            if selector == #selector(insertNewline(_:)) {
                onCommit?()
                return
            }
            if selector == #selector(cancelOperation(_:)) {
                onCancel?()
                return
            }
            super.doCommand(by: selector)
        }
    }
}
