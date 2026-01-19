// Views/KeyEventCatcher.swift
//
// キー入力を “firstResponder を奪わずに” 捕まえる
// - NSEvent.addLocalMonitorForEvents(.keyDown) を使う
// - handler が true を返したらイベントを握る（nil 返し）
// - false の場合は素通し（次へ流す）
//

import SwiftUI
import AppKit

struct KeyEventCatcher: NSViewRepresentable {

    typealias Handler = (NSEvent) -> Bool

    let handler: Handler

    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        context.coordinator.start(handler: handler)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        context.coordinator.update(handler: handler)
    }

    static func dismantleNSView(_ nsView: NSView, coordinator: Coordinator) {
        coordinator.stop()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        private var monitor: Any?
        private var handler: Handler?

        func start(handler: @escaping Handler) {
            self.handler = handler
            stop()

            // ✅ ローカルモニタ：firstResponder を奪わない
            monitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
                guard let self else { return event }
                guard let handler = self.handler else { return event }

                if handler(event) {
                    // ✅ 握る
                    return nil
                } else {
                    // ✅ 素通し
                    return event
                }
            }
        }

        func update(handler: @escaping Handler) {
            self.handler = handler
        }

        func stop() {
            if let monitor {
                NSEvent.removeMonitor(monitor)
                self.monitor = nil
            }
        }
    }
}
