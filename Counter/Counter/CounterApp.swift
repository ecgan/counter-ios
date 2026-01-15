import SwiftUI
import Combine
import UIKit

@main
struct CounterApp: App {
    @StateObject private var counterState = CounterState()
    @StateObject private var volumeListener = VolumeListener()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(counterState)
                .environmentObject(volumeListener)
                .onReceive(volumeListener.eventPublisher) { event in
                    handleVolumeEvent(event)
                }
                .onChange(of: scenePhase) { newPhase in
                    handleScenePhaseChange(newPhase)
                }
        }
    }

    private func handleVolumeEvent(_ event: VolumeEvent) {
        switch event.type {
        case .volumeUp:
            counterState.increment()
            provideHapticFeedback(.light)
        case .volumeDown:
            counterState.decrement()
            provideHapticFeedback(.light)
        case .reset:
            counterState.reset()
            provideHapticFeedback(.medium)
        }
    }

    private func provideHapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    private func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .active:
            volumeListener.startListening()
        case .inactive, .background:
            volumeListener.stopListening()
        @unknown default:
            break
        }
    }
}
