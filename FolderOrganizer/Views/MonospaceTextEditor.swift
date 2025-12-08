import SwiftUI

struct MonospaceTextEditor: View {
    @Binding var text: String
    var onCommit: () -> Void
    var onCancel: () -> Void

    var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 16, design: .monospaced))
            .foregroundColor(.black)
            .scrollContentBackground(.hidden)   // ← TextEditor の内部背景を消す
            .background(Color.white)            // ← 自前の白背景を適用
            .padding(8)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .onAppear {
                moveCursorToEnd()
            }
            // Enter
            .onKeyPress(.return) {      // 引数なし                onCommit()
                return .handled
            }
            // Esc
            .onKeyPress(.escape) {      // 引数なし                onCancel()
                return .handled
            }
    }

    private func moveCursorToEnd() {
        DispatchQueue.main.async {
            NSApp.keyWindow?.firstResponder?
                .tryToPerform(#selector(NSTextView.moveToEndOfDocument(_:)), with: nil)
        }
    }
}
