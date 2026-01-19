//
//  Views/Rename/RenameTextField.swift
//
//  単行編集用 NSTextField
//  ・Enter = commit
//  ・Esc = cancel
//  ・カーソル初期位置のみ末尾
//

import SwiftUI
import AppKit

struct RenameTextField: NSViewRepresentable {

    @Binding var text: String
    let onCommit: () -> Void
    let onCancel: () -> Void

    func makeNSView(context: Context) -> NSTextField {
        let field = NSTextField(string: text)
        field.isEditable = true
        field.isBordered = true
        field.font = NSFont.systemFont(ofSize: 15)
        field.delegate = context.coordinator

        field.usesSingleLineMode = true
        field.cell?.wraps = false
        field.cell?.isScrollable = true

        // 初回フォーカス時にのみカーソル末尾
        DispatchQueue.main.async {
            field.window?.makeFirstResponder(field)
            if let editor = field.currentEditor() {
                editor.selectedRange = NSRange(location: field.stringValue.count, length: 0)
            }
        }

        return field
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        // ★ カーソルを絶対に触らない
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, NSTextFieldDelegate {

        let parent: RenameTextField

        init(_ parent: RenameTextField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let field = obj.object as? NSTextField else { return }
            parent.text = field.stringValue
        }

        func control(_ control: NSControl,
                     textView: NSTextView,
                     doCommandBy commandSelector: Selector) -> Bool {

            switch commandSelector {
            case #selector(NSResponder.insertNewline(_:)):
                parent.onCommit()
                return true

            case #selector(NSResponder.cancelOperation(_:)):
                parent.onCancel()
                return true

            default:
                return false
            }
        }
    }
}
