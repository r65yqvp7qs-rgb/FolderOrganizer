//  Views/Rename/Edit/RenameTextEditor.swift
//
//  NSViewRepresentable Editor（NSTextView）
//  - 文字が見えない問題の対策：isRichText=false + typingAttributes + textColor
//  - 折り返し：textContainer.widthTracksTextView + containerSize を contentSize に追従
//  - フォーカス：wantsFocus=true で firstResponder + 末尾カーソル（選択解除）
//  - Enter：確定（改行させない） / Esc：キャンセル
//

import SwiftUI
import AppKit

struct RenameTextEditor: NSViewRepresentable {

    // MARK: - Bindings

    @Binding var text: String
    @Binding var wantsFocus: Bool

    // MARK: - Callbacks

    let onCommit: () -> Void
    let onCancel: () -> Void

    // MARK: - NSViewRepresentable

    func makeNSView(context: Context) -> NSScrollView {

        // ✅ TextView（中身）
        let textView = RenameEditTextView()
        textView.string = text

        // ---- 見た目（文字が見えない対策の核心）----
        textView.isRichText = false
        textView.importsGraphics = false
        textView.allowsImageEditing = false
        textView.usesAdaptiveColorMappingForDarkAppearance = true

        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true

        textView.textColor = NSColor.labelColor
        textView.insertionPointColor = NSColor.controlAccentColor
        textView.drawsBackground = false
        textView.backgroundColor = .clear

        // ✅ typingAttributes を明示（これが無いと「見えない」系が起きやすい）
        textView.typingAttributes = [
            .foregroundColor: NSColor.labelColor,
            .font: NSFont.systemFont(ofSize: 16)
        ]

        // ---- フォント ----
        textView.font = NSFont.systemFont(ofSize: 16)

        // ---- 折り返し（TextContainer 追従）----
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true

        textView.minSize = NSSize(width: 0, height: 0)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude,
                                  height: CGFloat.greatestFiniteMagnitude)

        // 見た目の余白（好みで調整OK）
        textView.textContainerInset = NSSize(width: 8, height: 10)

        if let container = textView.textContainer {
            container.widthTracksTextView = true
            container.heightTracksTextView = false
            container.lineFragmentPadding = 0
            container.lineBreakMode = .byWordWrapping
        }

        // ---- Enter/Esc + テキスト変更 ----
        textView.onTextChange = { newText in
            // ここは同期でOK（キーボードレスポンス優先）
            self.text = newText
        }
        textView.onCommit = onCommit
        textView.onCancel = onCancel

        // ✅ ScrollView（外側）
        let scrollView = NSScrollView()
        scrollView.documentView = textView
        scrollView.drawsBackground = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true

        // 初期はとりあえず幅追従（updateNSViewで確定させる）
        textView.autoresizingMask = [.width]

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? RenameEditTextView else { return }

        // ✅ 折り返し：textContainer の幅を ScrollView の content 幅へ追従させる
        let contentWidth = max(1, nsView.contentSize.width)
        if let container = textView.textContainer {
            let newSize = NSSize(width: contentWidth, height: CGFloat.greatestFiniteMagnitude)
            if container.containerSize.width != newSize.width {
                container.containerSize = newSize
                textView.invalidateIntrinsicContentSize()
            }
        }

        // ✅ 表示テキスト同期
        if textView.string != text {
            textView.string = text

            // typingAttributes が外れて「見えない」事故を避けるため再注入
            textView.textColor = NSColor.labelColor
            textView.typingAttributes = [
                .foregroundColor: NSColor.labelColor,
                .font: NSFont.systemFont(ofSize: 16)
            ]
        }

        // ✅ フォーカス要求が来た時だけ、末尾にカーソル（＝全選択しない）
        if wantsFocus {
            DispatchQueue.main.async {
                textView.window?.makeFirstResponder(textView)

                // 末尾にカーソル（Delete で全消しにならない）
                let end = (textView.string as NSString).length
                textView.setSelectedRange(NSRange(location: end, length: 0))
                textView.scrollRangeToVisible(NSRange(location: end, length: 0))

                // wantsFocus を落とす（連続で強制フォーカスしない）
                self.wantsFocus = false
            }
        }
    }
}

// MARK: - NSTextView subclass

final class RenameEditTextView: NSTextView {

    var onTextChange: ((String) -> Void)?
    var onCommit: (() -> Void)?
    var onCancel: (() -> Void)?

    override func didChangeText() {
        super.didChangeText()
        onTextChange?(string)
    }

    // ✅ Enter/Esc を確実に拾う（改行は発生させない）
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 36, 76: // Return / Enter(テンキー)
            onCommit?()
            return
        case 53: // Esc
            onCancel?()
            return
        default:
            break
        }
        super.keyDown(with: event)
    }

    // ✅ コマンド経由の改行も潰す（insertNewline: 等）
    override func doCommand(by selector: Selector) {
        switch selector {
        case #selector(insertNewline(_:)),
             #selector(insertNewlineIgnoringFieldEditor(_:)):
            onCommit?()
            return

        case #selector(cancelOperation(_:)):
            onCancel?()
            return

        default:
            break
        }
        super.doCommand(by: selector)
    }
}
