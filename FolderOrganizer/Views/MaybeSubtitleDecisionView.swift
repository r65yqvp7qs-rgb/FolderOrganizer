// Views/MaybeSubtitleDecisionView.swift
import SwiftUI

struct MaybeSubtitleDecisionView: View {

    let plan: RenamePlan
    @ObservedObject var decisionStore: UserDecisionStore

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("この文字列を Subtitle として扱いますか？")
                .font(.headline)

            if let maybe = plan.maybeSubtitle {
                Text(maybe)
                    .font(.title3)
                    .padding()
            } else {
                Text("（候補なし）")
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {

                Button {
                    decisionStore.setSubtitleDecision(.confirmAsSubtitle, for: plan.originalURL)
                    dismiss()
                } label: {
                    Text("Subtitle にする")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    decisionStore.setSubtitleDecision(.ignore, for: plan.originalURL)
                    dismiss()
                } label: {
                    Text("無視する")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
