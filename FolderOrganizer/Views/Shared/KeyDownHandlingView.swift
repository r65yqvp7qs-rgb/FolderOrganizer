// Views/Shared/KeyDownHandlingView.swift
//
// NSEvent を直接拾うための View
//

import SwiftUI
import AppKit

struct KeyDownHandlingView: NSViewRepresentable {

    let onKeyDown: (NSEvent) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        let monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            onKeyDown(event)
            return event
        }
        context.coordinator.monitor = monitor
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var monitor: Any?
        deinit {
            if let monitor {
                NSEvent.removeMonitor(monitor)
            }
        }
    }
}
