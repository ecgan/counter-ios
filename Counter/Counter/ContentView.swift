import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var counterState: CounterState
    @State private var showResetFeedback = false

    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Large counter display
                counterDisplay

                Spacer()

                // On-screen buttons (for App Store compliance and accessibility)
                buttonControls

                Spacer()
                    .frame(height: 40)
            }
            .padding()
        }
        .animation(.easeInOut(duration: 0.2), value: showResetFeedback)
    }

    // MARK: - Counter Display

    private var counterDisplay: some View {
        Text("\(counterState.value)")
            .font(.system(size: 120, weight: .bold, design: .rounded))
            .foregroundColor(showResetFeedback ? .green : .primary)
            .minimumScaleFactor(0.3)
            .lineLimit(1)
            .accessibilityLabel("Counter")
            .accessibilityValue("\(counterState.value)")
            .accessibilityHint("Use volume buttons to count: up to add, down to subtract, both to reset")
            .accessibilityAddTraits(.updatesFrequently)
    }

    // MARK: - Button Controls (App Store Compliance)

    private var buttonControls: some View {
        HStack(spacing: 60) {
            // Decrement button
            Button(action: {
                counterState.decrement()
                provideHapticFeedback(.light)
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
            }
            .accessibilityLabel("Decrease counter")
            .accessibilityHint("Decreases the counter by 1")

            // Reset button
            Button(action: {
                counterState.reset()
                triggerResetFeedback()
                provideHapticFeedback(.medium)
            }) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
            }
            .accessibilityLabel("Reset counter")
            .accessibilityHint("Resets the counter to zero")

            // Increment button
            Button(action: {
                counterState.increment()
                provideHapticFeedback(.light)
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
            }
            .accessibilityLabel("Increase counter")
            .accessibilityHint("Increases the counter by 1")
        }
    }

    // MARK: - Feedback

    private func triggerResetFeedback() {
        showResetFeedback = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showResetFeedback = false
        }
    }

    private func provideHapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

#Preview {
    ContentView()
        .environmentObject(CounterState())
}
