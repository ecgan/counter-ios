# Quickstart: Counter iOS App

**Date**: 2026-01-14
**Branch**: `001-init-spec-kit`

## Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 15.0+ device (volume buttons don't work in simulator)
- Apple ID (free) or Apple Developer Program ($99/year for easier family sharing)

## Project Setup

### 1. Create Xcode Project

```bash
# From repository root
open -a Xcode
```

1. File → New → Project
2. Select "App" under iOS
3. Configure:
   - Product Name: `Counter`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Use Core Data: ❌
   - Include Tests: ❌ (optional per constitution)
4. Save to repository root as `Counter/`

### 2. Project Configuration

**Deployment Target**: iOS 15.0

**Required Capabilities**: None (no special entitlements needed)

**Info.plist Additions**: None required

### 3. Directory Structure

After setup, the project should look like:

```text
Counter/
├── Counter.xcodeproj/
├── Counter/
│   ├── CounterApp.swift         # App entry point
│   ├── ContentView.swift        # Main UI
│   ├── Models/
│   │   └── CounterState.swift   # Counter state management
│   ├── Services/
│   │   └── VolumeListener.swift # Volume button detection
│   └── Assets.xcassets/
└── specs/                       # This documentation
```

## Running the App

### Simulator (Limited)

```bash
# Build and run in simulator (volume buttons won't work)
xcodebuild -scheme Counter -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Physical Device (Required for full testing)

1. Connect iOS device via USB
2. Select device in Xcode scheme dropdown
3. Press Cmd+R to build and run
4. Trust developer certificate if prompted

## Development Workflow

### Build

```bash
xcodebuild -scheme Counter -destination 'generic/platform=iOS' build
```

### Clean Build

```bash
xcodebuild -scheme Counter clean build
```

### Archive for Distribution

```bash
xcodebuild -scheme Counter -archivePath ./build/Counter.xcarchive archive
```

## Testing

Per Constitution v1.1.0, manual testing is the primary validation method.

### Manual Test Checklist

| Test | Expected Result |
|------|-----------------|
| Launch app | Counter shows 0 |
| Press volume up | Counter increases by 1 |
| Press volume down | Counter decreases by 1 |
| Tap Reset button | Counter resets to 0 |
| Kill and relaunch app | Counter shows previous value |
| Background app | Volume controls system volume |
| Foreground app | Volume controls counter |

### Performance Validation

| Metric | Target | How to Verify |
|--------|--------|---------------|
| Button response | <50ms | Instruments → Time Profiler |
| Startup time | <500ms | Instruments → App Launch |
| Memory usage | <50MB | Xcode Memory Debugger |

## Troubleshooting

### Volume buttons not detected

1. Ensure app is in foreground
2. Check device is not in Silent mode
3. Verify audio session is active (check console logs)

### Counter not persisting

1. Check UserDefaults access in Console
2. Verify no iCloud sync interference
3. Test with fresh install

## Installing on Personal Devices

This app is designed for personal/family use without App Store distribution. Volume button interception works without restrictions when sideloading.

### Option 1: Free Apple ID (You Only)

Best for: Single device, don't mind weekly reinstalls.

1. In Xcode, sign in with your Apple ID (Xcode → Settings → Accounts)
2. Connect iPhone via USB
3. Select your device in the scheme dropdown
4. Press Cmd+R to build and run
5. On iPhone: Settings → General → VPN & Device Management → Trust your developer certificate

**Limitations**:
- App expires after **7 days** (reinstall from Xcode)
- Maximum **3 apps** sideloaded at once
- Must have Mac nearby to reinstall

### Option 2: Apple Developer Program (Family Sharing)

Best for: Multiple family devices, long-term convenience. Costs $99/year.

#### Via Xcode (Direct Install)

1. Enroll at [developer.apple.com](https://developer.apple.com/programs/)
2. In Xcode, select your Developer team in Signing & Capabilities
3. Connect each family member's iPhone via USB
4. Build and run (Cmd+R) for each device

Apps last **1 year** before needing re-signing.

#### Via TestFlight (No Cable Needed)

Family members can install without connecting to your Mac:

1. Archive the app: Product → Archive
2. Distribute via TestFlight (App Store Connect)
3. Family members download TestFlight app and accept invite
4. Install Counter from TestFlight

**Note**: TestFlight builds also last 90 days.

#### Via Ad Hoc Distribution

For direct .ipa sharing without TestFlight:

1. Collect device UDIDs from family (Settings → General → About → tap Serial Number repeatedly)
2. Register devices in Apple Developer portal (up to 100 devices)
3. Create Ad Hoc provisioning profile including all devices
4. Archive → Distribute App → Ad Hoc
5. Share .ipa file (AirDrop, email, etc.)
6. Family installs via Apple Configurator or similar

### Device Registration (Developer Program)

To find a device's UDID for Ad Hoc distribution:

```bash
# With device connected via USB
xcrun xctrace list devices
```

Or on the iPhone: Settings → General → About → tap Serial Number 5 times to reveal UDID.

## App Store Submission (Future Reference)

If you decide to publish to the App Store later, be aware of potential review challenges.

### Risk: Guideline 2.5.9

Apple's App Store Review Guideline 2.5.9 states:

> "Apps that alter or disable the functions of standard switches, such as the Volume Up/Down and Ring/Silent switches, or other native user interface elements or behaviors will be rejected."

### Mitigation Strategy

1. **Frame as accessibility feature**: Emphasize hands-free counting for users who cannot touch the screen
2. **Include on-screen buttons**: Provide tap-based increment/decrement as primary UI, volume buttons as secondary
3. **Preserve system behavior**: Ensure volume buttons control system volume when app is backgrounded
4. **Clear review notes**: Include explanation in App Store Connect submission

### Recommended Review Notes

When submitting, include in App Store Connect → App Review Information → Notes:

> "This app provides an accessibility feature allowing users to count items hands-free using volume buttons while the app is in the foreground. This is designed for users who cannot easily touch the screen (e.g., when wearing gloves, holding items, or with motor impairments). On-screen buttons are also provided as the primary interface. Volume button functionality is fully restored when the app enters the background, preserving normal system behavior."

### Submission Checklist

- [ ] On-screen +/- buttons implemented as primary UI
- [ ] Volume buttons documented as accessibility feature
- [ ] System volume works normally when app backgrounded
- [ ] Review notes explain accessibility use case
- [ ] Screenshots show on-screen button interface

## Next Steps

See [tasks.md](tasks.md) for implementation tasks (generated by `/speckit.tasks`).
