import Foundation

/// Represents a volume button event
struct VolumeEvent: Equatable {
    let type: VolumeEventType
    let timestamp: Date

    init(type: VolumeEventType, timestamp: Date = Date()) {
        self.type = type
        self.timestamp = timestamp
    }
}

/// Types of volume button events
enum VolumeEventType: Equatable {
    /// Volume up button pressed
    case volumeUp

    /// Volume down button pressed
    case volumeDown

    /// Both buttons pressed simultaneously (within 100ms)
    case reset
}
