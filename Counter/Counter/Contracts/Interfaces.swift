// Counter iOS App - Interface Contracts
// Date: 2026-01-14
// Branch: 001-init-spec-kit
//
// This file defines the public interfaces (protocols) for the Counter app.
// Implementation files MUST conform to these contracts.

import Foundation
import Combine

// MARK: - Counter State Protocol

/// Protocol defining the counter state management interface
protocol CounterStateProtocol: ObservableObject {
    /// Current counter value (can be negative)
    var value: Int { get }

    /// Timestamp of last value change
    var lastUpdated: Date { get }

    /// Increment the counter by 1
    /// - Postcondition: value increases by 1
    /// - Postcondition: lastUpdated is set to current time
    /// - Postcondition: value is persisted to UserDefaults
    func increment()

    /// Decrement the counter by 1
    /// - Postcondition: value decreases by 1
    /// - Postcondition: lastUpdated is set to current time
    /// - Postcondition: value is persisted to UserDefaults
    func decrement()

    /// Reset the counter to 0
    /// - Postcondition: value is set to 0
    /// - Postcondition: lastUpdated is set to current time
    /// - Postcondition: value is persisted to UserDefaults
    func reset()
}

// MARK: - Volume Listener Protocol

/// Protocol defining the volume button listener interface
protocol VolumeListenerProtocol: ObservableObject {
    /// Publisher emitting volume button events
    var eventPublisher: AnyPublisher<VolumeEvent, Never> { get }

    /// Whether the listener is currently active
    var isListening: Bool { get }

    /// Start listening for volume button events
    /// - Precondition: App is in foreground
    /// - Postcondition: isListening is true
    /// - Postcondition: eventPublisher emits events on button press
    func startListening()

    /// Stop listening for volume button events
    /// - Postcondition: isListening is false
    /// - Postcondition: System volume control is restored
    func stopListening()
}

// MARK: - Performance Contracts

/// Performance requirements that implementations must meet
enum PerformanceContract {
    /// Maximum time from button press to UI update
    static let maxResponseTimeMs: Int = 50

    /// Debounce interval between registered presses
    static let debounceIntervalMs: Int = 150

    /// Threshold for detecting simultaneous button press
    static let simultaneousThresholdMs: Int = 100

    /// Maximum app memory usage in MB
    static let maxMemoryMB: Int = 50

    /// Maximum app startup time in ms
    static let maxStartupTimeMs: Int = 500

    /// Maximum battery drain per hour of active use (percentage)
    static let maxBatteryPercentPerHour: Double = 1.0
}

// MARK: - Accessibility Contract

/// Accessibility requirements for UI elements
protocol AccessibleCounterDisplay {
    /// VoiceOver label for the counter display
    var accessibilityLabel: String { get }

    /// VoiceOver value announcement (the count)
    var accessibilityValue: String { get }

    /// VoiceOver hint explaining how to use
    var accessibilityHint: String { get }
}
