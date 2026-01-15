# Implementation Plan: Counter iOS App with Volume Button Control

**Branch**: `001-init-spec-kit` | **Date**: 2026-01-14 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/001-init-spec-kit/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Build a native iOS counter app that uses physical volume buttons for hands-free increment/decrement operations. The app intercepts volume button presses while in foreground, displays a large readable counter, persists state via UserDefaults, and supports reset via simultaneous button press. Built with SwiftUI targeting iOS 15+.

## Technical Context

**Language/Version**: Swift 5.9 (or latest Xcode default)
**Primary Dependencies**: SwiftUI, AVFoundation (for volume button interception), Combine
**Storage**: UserDefaults (simple key-value persistence for counter state)
**Testing**: Manual testing (per constitution v1.1.0 - automated tests optional)
**Target Platform**: iOS 15.0+
**Project Type**: Mobile (single iOS app)
**Performance Goals**: <50ms button-to-UI update, <500ms app startup, 60fps UI
**Constraints**: <50MB memory, <1% battery/hour active use, offline-capable (no network required)
**Scale/Scope**: Single-screen app, 1 entity (Counter), ~10-15 source files

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Design Gate Check (Phase 0)

| Principle | Requirement | Plan Compliance | Status |
|-----------|-------------|-----------------|--------|
| **Code Quality** | Self-documenting code, single responsibility, type safety, explicit error handling | SwiftUI with Swift strict typing, small focused components | ✅ PASS |
| **UX Consistency** | <100ms feedback, state always visible, gesture predictability, accessibility, offline-first | <50ms target, single large counter display, volume buttons = consistent actions, VoiceOver support planned, no network required | ✅ PASS |
| **Performance** | <50ms volume events, <1% battery/hr, <50MB memory, <500ms startup, immediate persistence | All targets included in Technical Context | ✅ PASS |

### Quality Gates

| Gate | Requirement | Plan Approach |
|------|-------------|---------------|
| Build | Zero warnings, zero errors | Xcode strict mode, CI automated |
| Performance | Response time benchmarks pass | Manual verification with profiling |
| Accessibility | VoiceOver audit passes | Manual review before release |
| Code Review | At least one approval required | GitHub PR rules |

### Testing Protocol (Constitution v1.1.0)

- Manual testing is primary validation method
- Automated tests are OPTIONAL
- Critical user flows manually verified before release

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
Counter/
├── Counter.xcodeproj/           # Xcode project file
├── Counter/
│   ├── CounterApp.swift         # App entry point, lifecycle handling
│   ├── ContentView.swift        # Main UI with large counter display
│   ├── Models/
│   │   └── CounterState.swift   # Counter state with UserDefaults persistence
│   ├── Services/
│   │   └── VolumeListener.swift # AVAudioSession KVO volume detection
│   └── Assets.xcassets/         # App icons, colors
└── CounterTests/                # Optional: manual tests primary
```

**Structure Decision**: iOS mobile app using standard Xcode project structure. Single app target with Models and Services subdirectories for separation of concerns. No API backend required (offline-first, local persistence only).

## Post-Design Constitution Check (Phase 1)

| Principle | Design Compliance | Status |
|-----------|-------------------|--------|
| **Code Quality** | CounterState with single responsibility (state + persistence), VolumeListener with single responsibility (event detection), strict Swift typing | ✅ PASS |
| **UX Consistency** | ContentView with always-visible counter, VoiceOver protocol defined in contracts, offline-first (no network) | ✅ PASS |
| **Performance** | Debounce (150ms) and response targets (<50ms) specified in PerformanceContract | ✅ PASS |

## Risk Register

| Risk | Severity | Mitigation |
|------|----------|------------|
| App Store rejection (Guideline 2.5.9) | HIGH | Frame as accessibility feature; include on-screen buttons as fallback; document in review notes |
| Volume detection at extremes | MEDIUM | Accept limitation; document in user guide |
| Silent mode detection failure | LOW | Document limitation; app still usable via on-screen buttons |

## Complexity Tracking

> No Constitution violations requiring justification. Design follows all principles.
