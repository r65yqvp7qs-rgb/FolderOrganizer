import SwiftUI

struct ContentView: View {
    @State private var items: [RenameItem] = []
    @State private var showingList = false
    
    var body: some View {
        ZStack {
            AppTheme.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Folder Organizer")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.colors.accent)
                
                Button(action: loadSample) {
                    Text("フォルダ名を読み込んで変換プレビュー")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(AppTheme.colors.accent)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                
                Divider()
                    .background(AppTheme.colors.border)
                    .padding(.horizontal, 8)
                
                if showingList {
                    RenamePreviewList(items: $items)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Spacer()
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 24)
        }
        // ウィンドウ最小サイズを大きめに
        .frame(minWidth: 1100, minHeight: 750)
    }
    
    func loadSample() {
        items = FileScanService.loadSampleNames()
        showingList = true
    }
}
