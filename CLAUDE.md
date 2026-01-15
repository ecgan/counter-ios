# counter Development Guidelines

Auto-generated from all feature plans. Last updated: 2026-01-14

## Active Technologies

- Swift 5.9 (or latest Xcode default) + SwiftUI, AVFoundation (for volume button interception), Combine (001-init-spec-kit)

## Project Structure

```text
src/
tests/
```

## Commands

```bash
# Build
xcodebuild -scheme Counter -destination 'generic/platform=iOS' build

# Clean build
xcodebuild -scheme Counter clean build

# Run on simulator (volume buttons won't work)
xcodebuild -scheme Counter -destination 'platform=iOS Simulator,name=iPhone 15' build

# Archive for distribution
xcodebuild -scheme Counter -archivePath ./build/Counter.xcarchive archive
```

## Code Style

Swift 5.9 (or latest Xcode default): Follow standard conventions

## Recent Changes

- 001-init-spec-kit: Added Swift 5.9 (or latest Xcode default) + SwiftUI, AVFoundation (for volume button interception), Combine

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
