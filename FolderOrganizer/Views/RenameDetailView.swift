//  Views/RenameDetailView.swift
import SwiftUI

struct RenameDetailView: View {

    let item: RenameItem
    let index: Int
    let total: Int

    let onPrev: () -> Void
    let onNext: () -> Void
    let onClose: () -> Void
    let onEdit: () -> Void   // Enter で編集へ

    // 一覧と同期した背景色
    private var detailBackgroundColor: Color {
        if TextClassifier.isSubtitle(item.normalized) {
            return AppTheme.colors.subtitleBackground
        }
        if TextClassifier.isPotentialSubtitle(item.normalized) {
            return AppTheme.colors.potentialSubtitleBackground
        }
        return AppTheme.colors.cardBackground
    }

    var body: some View {
        ZStack {
            // うっすら暗く（後ろの一覧）が見えるオーバーレイ
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    onClose()          // 枠外クリックで閉じる
                }

            VStack(alignment: .leading, spacing: 20) {

                // 上部：閉じるボタン
                HStack {
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }

                // 旧
                HStack(alignment: .top, spacing: 6) {
                    Text("旧:")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(AppTheme.colors.oldText)

                    Text(item.original)
                        .font(.system(size: 19))
                        .foregroundColor(AppTheme.colors.oldText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // 新（自動） ここでスペースを可視化
                HStack(alignment: .top, spacing: 6) {
                    Text("新:")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundColor(AppTheme.colors.newText)

                    DiffBuilder.highlightSpaces(in: item.normalized)
                        .font(.system(size: 19))
                        .foregroundColor(AppTheme.colors.newText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // 操作ガイド
                Text("Enter で編集 / ↑↓ で移動 / Esc で閉じる")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                Spacer()

                // 右下：前へ / 現在位置 / 次へ
                HStack {
                    Spacer()
                    VStack(spacing: 10) {

                        Button(action: onPrev) {
                            Image(systemName: "chevron.up.circle.fill")
                                .resizable()
                                .frame(width: 34, height: 34)
                                .foregroundColor(Color.accentColor)
                        }
                        .disabled(index == 0)

                        Text("\(index + 1) / \(total)")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)

                        Button(action: onNext) {
                            Image(systemName: "chevron.down.circle.fill")
                                .resizable()
                                .frame(width: 34, height: 34)
                                .foregroundColor(Color.accentColor)
                        }
                        .disabled(index >= total - 1)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 8)
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 20)
            .frame(width: 720, height: 420)
            .background(detailBackgroundColor)
            .cornerRadius(18)
            .shadow(radius: 8)
        }
        // キーボード操作
        .onKeyDown { event in
            switch event.keyCode {
            case 126: // ↑
                onPrev()
            case 125: // ↓
                onNext()
            case 36, 76: // Enter → 編集モードへ
                onEdit()
            case 53:  // Esc
                onClose()
            default:
                break
            }
        }
    }
}
