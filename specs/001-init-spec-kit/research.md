# Research: Counter iOS App with Volume Button Control

**Date**: 2026-01-14
**Branch**: `001-init-spec-kit`

## Research Questions

### 1. iOS Volume Button Interception

**Decision**: AVAudioSession KVO (Key-Value Observing) on `outputVolume`

**Rationale**:
- Only available public API mechanism for detecting volume button presses
- Works with SwiftUI applications through proper state management
- Can reset volume immediately to prevent user-facing changes
- Compatible with iOS 15+

**Alternatives Considered**:

| Alternative | Why Rejected |
|-------------|--------------|
| JPSVolumeButtonHandler (third-party) | Archived/obsolete, violates App Store Guideline 2.5.9 |
| Direct hardware button interception | No public API exists |
| Audio session delegate callbacks | AVAudioSession doesn't provide these; KVO is the only option |

**Critical App Store Risk**:

> **Guideline 2.5.9**: "Apps that alter or disable the functions of standard switches, such as the Volume Up/Down and Ring/Silent switches, will be rejected."

**Mitigation Strategy**:
- Document the feature clearly in App Store review notes
- Frame as accessibility feature for hands-free counting
- Ensure volume control remains functional (only intercept, don't block)
- Consider providing on-screen buttons as fallback for App Store compliance

**Technical Limitations**:
- Detection fails when device is in Silent/Mute mode
- May be unreliable at volume extremes (0 or max)
- No native simultaneous button detection (requires timing-based workaround)
- Works only on physical devices, not simulator

---

### 2. Simultaneous Button Detection

**Decision**: Timing-based detection with 100ms window

**Rationale**:
- KVO fires separate observations for each button
- Track last event time for each button
- If both events occur within 100ms, treat as simultaneous press

**Implementation Pattern**:
```swift
private var lastVolumeUpTime: Date?
private var lastVolumeDownTime: Date?
private let simultaneousThreshold: TimeInterval = 0.1 // 100ms

func detectSimultaneousPress() -> Bool {
    guard let upTime = lastVolumeUpTime,
          let downTime = lastVolumeDownTime else { return false }
    return abs(upTime.timeIntervalSince(downTime)) < simultaneousThreshold
}
```

**Alternatives Considered**:

| Alternative | Why Rejected |
|-------------|--------------|
| Native simultaneous detection | Not supported by iOS APIs |
| Hardware-level detection | Requires private APIs, App Store rejection |

---

### 3. SwiftUI State Persistence Pattern

**Decision**: `@Published` property with `didSet` + `@StateObject` pattern

**Rationale**:
- Automatic persistence on every change via `didSet`
- Single source of truth with `@StateObject`
- Clean dependency injection via `@EnvironmentObject`
- Built-in app lifecycle integration through `.scenePhase`
- iOS 15+ compatible

**Alternatives Considered**:

| Alternative | Why Rejected |
|-------------|--------------|
| Direct UserDefaults calls | Scattered logic, easy to miss saves |
| Core Data | Overkill for single integer value |
| SwiftData | Requires iOS 17+, app targets iOS 15+ |
| @AppStorage | Limited scalability for app-wide state |

**Key Pattern**:
```swift
class CounterState: ObservableObject {
    @Published var count: Int = 0 {
        didSet {
            UserDefaults.standard.set(count, forKey: "counter_value")
        }
    }

    init() {
        self.count = UserDefaults.standard.integer(forKey: "counter_value")
    }
}
```

---

### 4. Debounce Implementation

**Decision**: 150ms debounce using Combine's `debounce` operator

**Rationale**:
- Matches spec requirement (FR-008: 150ms delay)
- Allows ~6 counts per second for rapid counting
- Combine is built-in, no external dependencies

**Implementation Pattern**:
```swift
import Combine

private var cancellables = Set<AnyCancellable>()
private let volumeEventSubject = PassthroughSubject<VolumeEvent, Never>()

init() {
    volumeEventSubject
        .debounce(for: .milliseconds(150), scheduler: DispatchQueue.main)
        .sink { [weak self] event in
            self?.handleVolumeEvent(event)
        }
        .store(in: &cancellables)
}
```

---

## Summary of Key Decisions

| Topic | Decision | Risk Level |
|-------|----------|------------|
| Volume Button Detection | AVAudioSession KVO observation | HIGH (App Store) |
| Simultaneous Press | 100ms timing window | LOW |
| State Persistence | @Published + didSet pattern | LOW |
| Debouncing | Combine debounce operator (150ms) | LOW |
| UI Framework | SwiftUI with @StateObject | LOW |

## App Store Strategy

Given the HIGH risk of App Store rejection for volume button interception:

1. **Primary Strategy**: Submit with clear App Review notes explaining accessibility use case
2. **Fallback Strategy**: Include on-screen increment/decrement buttons as alternative
3. **Test Strategy**: Test submission to identify specific objections if any

## Open Questions Resolved

All NEEDS CLARIFICATION items from Technical Context have been resolved through this research.
