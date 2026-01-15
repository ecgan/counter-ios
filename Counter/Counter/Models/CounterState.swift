import Foundation

/// Counter state model with automatic persistence
/// Conforms to CounterStateProtocol from Interfaces.swift
final class CounterState: ObservableObject, CounterStateProtocol {
    /// Current counter value (can be negative)
    @Published private(set) var value: Int = 0 {
        didSet {
            lastUpdated = Date()
            persist()
        }
    }

    /// Timestamp of last value change
    @Published private(set) var lastUpdated: Date = Date()

    private let persistenceKey = "counter_value"

    init() {
        loadPersistedState()
    }

    // MARK: - Actions

    /// Increment the counter by 1
    func increment() {
        value += 1
    }

    /// Decrement the counter by 1
    func decrement() {
        value -= 1
    }

    /// Reset the counter to 0
    func reset() {
        value = 0
    }

    // MARK: - Persistence

    private func persist() {
        UserDefaults.standard.set(value, forKey: persistenceKey)
    }

    private func loadPersistedState() {
        let savedValue = UserDefaults.standard.integer(forKey: persistenceKey)
        // Set without triggering didSet to avoid double persistence
        _value = Published(initialValue: savedValue)
    }
}
