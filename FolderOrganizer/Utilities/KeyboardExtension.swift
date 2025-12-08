import SwiftUI

// MARK: - ViewModifier

struct KeyDownModifier: ViewModifier {
    let onKeyDown: (NSEvent) -> Void

    func body(content: Content) -> some View {
        content
            .background(
                KeyDownView(onKeyDown: onKeyDown)
                    .frame(width: 0, height: 0)
            )
    }
}

extension View {
    func onKeyDown(perform: @escaping (NSEvent) -> Void) -> some View {
        self.modifier(KeyDownModifier(onKeyDown: perform))
    }
}

// MARK: - NSViewRepresentable（struct にする！）

struct KeyDownView: NSViewRepresentable {

    let onKeyDown: (NSEvent) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = KeyCaptureNSView()
        view.onKeyDown = onKeyDown

        // View が作られたら firstResponder にする
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) { }
}

// MARK: - 実際にキーを受け取る NSView

final class KeyCaptureNSView: NSView {

    var onKeyDown: ((NSEvent) -> Void)?

    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        onKeyDown?(event)
    }
}
