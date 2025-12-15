// Views/DryRunPreviewView.swift
import SwiftUI

struct DryRunPreviewView: View {

    @StateObject private var decisionStore = UserDecisionStore()

    let itemURLs: [URL]
    let engine: RenamePlanEngine

    @State private var plans: [RenamePlan] = []

    var body: some View {
        ApplyConfirmationView(plans: plans)
            .onAppear {
                rebuildPlans()
            }
            // Subtitle の意思決定が変わったら再生成
            .onReceive(decisionStore.$subtitleDecisions) { _ in
                rebuildPlans()
            }
            // Author の意思決定が変わったら再生成（今は最小だけど将来の拡張に備えて入れておく）
            .onReceive(decisionStore.$authorDecisions) { _ in
                rebuildPlans()
            }
    }

    // MARK: - Build plans

    private func rebuildPlans() {
        plans = itemURLs.map { url in
            engine.generatePlan(
                for: url,
                subtitleDecision: decisionStore.subtitleDecision(for: url),
                authorDecision: decisionStore.authorDecision(for: url)
            )
        }
    }
}
