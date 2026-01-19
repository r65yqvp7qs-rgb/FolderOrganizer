//
//  Infrastructure/KeyFocusController.swift
//
//  一覧用キーボードフォーカス管理
//  ・KeyEventCatcher を first responder に戻す責務
//  ・編集 Overlay 終了時に必ず呼ばれる
//

import AppKit
import Combine

final class KeyFocusController: ObservableObject {

    /// 一覧操作用の first responder を強制的に取り戻す
    func makeFirstResponder() {
        DispatchQueue.main.async {
            guard
                let window = NSApp.keyWindow,
                let contentView = window.contentView
            else { return }

            // contentView 配下で acceptsFirstResponder な View を探す
            if let responder = self.findFirstResponderCandidate(in: contentView) {
                window.makeFirstResponder(responder)
            }
        }
    }

    // MARK: - Private

    private func findFirstResponderCandidate(in view: NSView) -> NSView? {
        if view.acceptsFirstResponder {
            return view
        }

        for subview in view.subviews {
            if let found = findFirstResponderCandidate(in: subview) {
                return found
            }
        }

        return nil
    }
}
