# Counter

A simple iOS counter app that uses volume buttons for hands-free counting.

## Features

- **Volume button counting**: Press volume up to increment, volume down to decrement
- **On-screen controls**: Fallback +/- buttons and Reset button
- **Persistence**: Counter value survives app restarts
- **Accessibility**: VoiceOver support

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Physical iOS device (volume buttons don't work in simulator)

## Development Setup

1. Clone the repository
2. Copy the xcconfig template:
   ```bash
   cp Counter/Counter/Config/Local.xcconfig.template Counter/Counter/Config/Local.xcconfig
   ```
3. Edit `Counter/Counter/Config/Local.xcconfig` and replace `YOUR_TEAM_ID_HERE` with your Apple Development Team ID
4. Open `Counter/Counter.xcodeproj` in Xcode
5. Build and run on a physical device

### Finding Your Team ID

Your Apple Development Team ID can be found in:
- Xcode: Preferences → Accounts → Select your account → View Details
- Apple Developer Portal: Membership details page

## Building

```bash
# Build for device
xcodebuild -scheme Counter -destination 'generic/platform=iOS' build

# Build for simulator (UI only - volume buttons won't work)
xcodebuild -scheme Counter -destination 'platform=iOS Simulator,name=iPhone 15' build
```

## License

MIT
