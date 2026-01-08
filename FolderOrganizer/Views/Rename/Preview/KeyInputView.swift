//
//  Views/Common/KeyInputView.swift
//  FolderOrganizer
//
//  macOS 専用キー入力ハンドラ（最小構成）
//  ↑ ↓ Enter Esc のみを扱う
//

import SwiftUI
import AppKit

struct KeyInputView: NSViewRepresentable {

    let onKeyDown: (NSEvent) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = KeyCatcher()
        view.onKeyDown = onKeyDown
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}

    // MARK: - NSView

    final class KeyCatcher: NSView {

        var onKeyDown: ((NSEvent) -> Void)?

        override var acceptsFirstResponder: Bool { true }

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            DispatchQueue.main.async { [weak self] in
                self?.window?.makeFirstResponder(self)
            }
        }

        override func keyDown(with event: NSEvent) {
            onKeyDown?(event)
        }
    }
}

// MARK: - View extension

extension View {
    func onKeyDown(_ handler: @escaping (NSEvent) -> Void) -> some View {
        background(KeyInputView(onKeyDown: handler))
    }
}
