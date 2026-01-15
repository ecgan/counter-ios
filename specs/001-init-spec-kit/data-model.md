# Data Model: Counter iOS App

**Date**: 2026-01-14
**Branch**: `001-init-spec-kit`

## Entities

### Counter

The single entity representing the counter state.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `value` | `Int` | Current counter value | No limits (supports negative) |
| `lastUpdated` | `Date` | Timestamp of last change | Auto-updated on mutation |

**Persistence**: UserDefaults with key `counter_value`

**State Transitions**:

```text
                    ┌─────────────────────────────────────┐
                    │                                     │
                    ▼                                     │
┌────────────┐    volume_up    ┌────────────┐           │
│  value: N  │ ─────────────▶  │ value: N+1 │           │
└────────────┘                 └────────────┘           │
      │                              │                  │
      │ volume_down                  │ volume_down      │
      ▼                              ▼                  │
┌────────────┐                 ┌────────────┐           │
│ value: N-1 │                 │  value: N  │           │
└────────────┘                 └────────────┘           │
      │                              │                  │
      │                              │                  │
      │          reset (both buttons)│                  │
      └──────────────────────────────┼──────────────────┘
                                     ▼
                              ┌────────────┐
                              │  value: 0  │
                              └────────────┘
```

**Validation Rules**:
- Value must be an integer (no decimal counting)
- No upper/lower bounds enforced (spec allows negative values)
- Display should handle at least 6 digits (up to 999,999)

---

## Swift Implementation

```swift
import Foundation

/// Counter state model with automatic persistence
final class CounterState: ObservableObject {
    /// Current counter value
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

    func increment() {
        value += 1
    }

    func decrement() {
        value -= 1
    }

    func reset() {
        value = 0
    }

    // MARK: - Persistence

    private func persist() {
        UserDefaults.standard.set(value, forKey: persistenceKey)
    }

    private func loadPersistedState() {
        value = UserDefaults.standard.integer(forKey: persistenceKey)
    }
}
```

---

## Volume Event Model

Represents events from volume button interactions.

| Field | Type | Description |
|-------|------|-------------|
| `type` | `VolumeEventType` | Type of volume event |
| `timestamp` | `Date` | When the event occurred |

**Event Types**:

```swift
enum VolumeEventType {
    case volumeUp
    case volumeDown
    case simultaneousBoth  // Both buttons pressed together
}
```

**Event Processing Flow**:

```text
┌──────────────────┐
│  Volume Button   │
│     Pressed      │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   KVO Callback   │
│  (outputVolume)  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Debounce Check  │──▶ Skip if within 150ms of last event
│     (150ms)      │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Simultaneous    │──▶ If both buttons within 100ms → Reset
│     Check        │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Apply Action    │
│  to CounterState │
└──────────────────┘
```

---

## Relationships

```text
┌─────────────────────┐
│   VolumeListener    │
│  (ObservableObject) │
└──────────┬──────────┘
           │ observes AVAudioSession
           │ emits VolumeEvent
           ▼
┌─────────────────────┐
│   CounterState      │
│  (ObservableObject) │
└──────────┬──────────┘
           │ persists to
           ▼
┌─────────────────────┐
│    UserDefaults     │
└─────────────────────┘
```

---

## Data Integrity

| Concern | Mitigation |
|---------|------------|
| App crash during save | UserDefaults is atomic; partial writes impossible |
| Concurrent access | Main thread only; no concurrency issues |
| Data corruption | UserDefaults handles serialization internally |
| First launch | `UserDefaults.integer(forKey:)` returns 0 for missing keys |
