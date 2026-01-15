# Tasks: Counter iOS App with Volume Button Control

**Input**: Design documents from `/specs/001-init-spec-kit/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Manual testing only (per Constitution v1.1.0 - automated tests optional and not requested)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

## Path Conventions

Based on plan.md structure:

```text
Counter/
├── Counter.xcodeproj/
├── Counter/
│   ├── CounterApp.swift
│   ├── ContentView.swift
│   ├── Models/
│   │   └── CounterState.swift
│   ├── Services/
│   │   └── VolumeListener.swift
│   └── Assets.xcassets/
```

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Xcode project initialization and directory structure

- [X] T001 Create Xcode project "Counter" with SwiftUI template at Counter/
- [X] T002 Configure deployment target to iOS 15.0 in Counter.xcodeproj
- [X] T003 [P] Create Models/ subdirectory at Counter/Counter/Models/
- [X] T004 [P] Create Services/ subdirectory at Counter/Counter/Services/
- [X] T005 [P] Copy interface contracts from specs/001-init-spec-kit/contracts/interfaces.swift to Counter/Counter/Contracts/Interfaces.swift

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T006 Implement VolumeEvent struct and VolumeEventType enum in Counter/Counter/Models/VolumeEvent.swift per contracts/interfaces.swift
- [X] T007 Implement CounterState class conforming to CounterStateProtocol in Counter/Counter/Models/CounterState.swift per data-model.md
- [X] T008 Implement VolumeListener class conforming to VolumeListenerProtocol with AVAudioSession KVO in Counter/Counter/Services/VolumeListener.swift per research.md
- [X] T009 Add debounce logic (150ms) using Combine in Counter/Counter/Services/VolumeListener.swift per PerformanceContract
- [X] T010 Add simultaneous button detection (100ms window) in Counter/Counter/Services/VolumeListener.swift per research.md
- [X] T011 Configure AVAudioSession for volume interception in Counter/Counter/Services/VolumeListener.swift
- [X] T012 Wire VolumeListener events to CounterState actions in Counter/Counter/CounterApp.swift

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 4 - View Current Count (Priority: P1) 🎯 MVP

**Goal**: Display the current count prominently on screen so users can easily read it at a glance

**Independent Test**: Open the app and verify a large, readable counter is displayed showing the current value

**Why First**: This is P1 priority and provides the visual foundation that all other stories depend on for feedback

### Implementation for User Story 4

- [X] T013 [US4] Create main ContentView with large centered counter display in Counter/Counter/ContentView.swift
- [X] T014 [US4] Style counter text for readability from arm's length (large font, high contrast) in Counter/Counter/ContentView.swift
- [X] T015 [US4] Add VoiceOver accessibility labels per AccessibleCounterDisplay contract in Counter/Counter/ContentView.swift
- [X] T016 [US4] Connect ContentView to CounterState via @EnvironmentObject in Counter/Counter/ContentView.swift
- [X] T017 [US4] Inject CounterState as environment object in Counter/Counter/CounterApp.swift

**Checkpoint**: User Story 4 complete - counter displays correctly and is accessible

---

## Phase 4: User Story 1 - Increment Counter with Volume Up (Priority: P1)

**Goal**: Press the physical volume up button to increment the counter by 1 for hands-free counting

**Independent Test**: Press the volume up button on a physical device and verify the counter display increases by 1

### Implementation for User Story 1

- [X] T018 [US1] Handle volumeUp events from VolumeListener to call CounterState.increment() in Counter/Counter/CounterApp.swift
- [X] T019 [US1] Verify system volume does not change when volume up is pressed (intercept working) in Counter/Counter/Services/VolumeListener.swift
- [X] T020 [US1] Add haptic feedback on increment (optional enhancement) in Counter/Counter/ContentView.swift

**Checkpoint**: User Story 1 complete - volume up increments counter without changing system volume

---

## Phase 5: User Story 2 - Decrement Counter with Volume Down (Priority: P2)

**Goal**: Press the physical volume down button to decrement the counter by 1 to correct counting mistakes

**Independent Test**: Press the volume down button on a physical device and verify the counter display decreases by 1

### Implementation for User Story 2

- [X] T021 [US2] Handle volumeDown events from VolumeListener to call CounterState.decrement() in Counter/Counter/CounterApp.swift
- [X] T022 [US2] Verify negative numbers display correctly in Counter/Counter/ContentView.swift
- [X] T023 [US2] Verify system volume does not change when volume down is pressed in Counter/Counter/Services/VolumeListener.swift

**Checkpoint**: User Story 2 complete - volume down decrements counter, negative values supported

---

## Phase 6: User Story 3 - Reset Counter with Both Volume Buttons (Priority: P3)

**Goal**: Press both volume buttons simultaneously to reset the counter to 0 for quick restart

**Independent Test**: Press both volume buttons together on a physical device and verify the counter resets to 0

### Implementation for User Story 3

- [X] T024 [US3] Handle reset events (simultaneous buttons) from VolumeListener to call CounterState.reset() in Counter/Counter/CounterApp.swift
- [X] T025 [US3] Add visual feedback for reset action (brief animation or color change) in Counter/Counter/ContentView.swift

**Checkpoint**: User Story 3 complete - both buttons pressed resets counter to 0

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories and app quality

- [X] T026 [P] Add app lifecycle handling - start/stop VolumeListener on foreground/background in Counter/Counter/CounterApp.swift using scenePhase
- [X] T027 [P] Add on-screen +/- buttons as fallback UI for App Store compliance in Counter/Counter/ContentView.swift
- [X] T028 [P] Add on-screen reset button for accessibility in Counter/Counter/ContentView.swift
- [X] T029 [P] Configure app icon in Counter/Counter/Assets.xcassets/
- [X] T030 [P] Configure launch screen colors in Counter/Counter/Assets.xcassets/
- [ ] T031 Run manual test checklist from quickstart.md on physical device
- [ ] T032 Verify persistence - kill and relaunch app, confirm counter value persists
- [ ] T033 Verify performance targets: <50ms response, <500ms startup per PerformanceContract

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 4 (Phase 3)**: Depends on Foundational - UI foundation for all other stories
- **User Stories 1-3 (Phases 4-6)**: Depend on Foundational + User Story 4 for visual feedback
- **Polish (Phase 7)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 4 (P1)**: Display - Can start after Foundational (Phase 2) - Required before other stories
- **User Story 1 (P1)**: Increment - Depends on US4 for visual feedback
- **User Story 2 (P2)**: Decrement - Depends on US4 for visual feedback, can run parallel with US1
- **User Story 3 (P3)**: Reset - Depends on US4 for visual feedback, can run parallel with US1/US2

### Within Each User Story

- Models before services
- Services before UI integration
- Core implementation before enhancements
- Story complete before moving to next priority

### Parallel Opportunities

- T003, T004, T005 can run in parallel (different directories)
- T026, T027, T028, T029, T030 can run in parallel (different files/concerns)
- US1, US2, US3 can run in parallel after US4 is complete (all depend on display)

---

## Parallel Example: Setup Phase

```bash
# Launch all parallel setup tasks together:
Task: "Create Models/ subdirectory at Counter/Counter/Models/"
Task: "Create Services/ subdirectory at Counter/Counter/Services/"
Task: "Copy interface contracts to Counter/Counter/Contracts/Interfaces.swift"
```

## Parallel Example: Polish Phase

```bash
# Launch all parallel polish tasks together:
Task: "Add app lifecycle handling in CounterApp.swift"
Task: "Add on-screen +/- buttons in ContentView.swift"
Task: "Add on-screen reset button in ContentView.swift"
Task: "Configure app icon in Assets.xcassets/"
Task: "Configure launch screen colors in Assets.xcassets/"
```

---

## Implementation Strategy

### MVP First (User Stories 4 + 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 4 (Display)
4. Complete Phase 4: User Story 1 (Increment)
5. **STOP and VALIDATE**: Test on physical device - can you see and increment?
6. Deploy/demo if ready (minimal viable counting app)

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 4 (Display) → Test on device (MVP!)
3. Add User Story 1 (Increment) → Test on device → Usable counter!
4. Add User Story 2 (Decrement) → Test on device → Full counting!
5. Add User Story 3 (Reset) → Test on device → Complete feature set!
6. Add Polish → App Store ready

### Physical Device Required

**⚠️ IMPORTANT**: Volume button functionality CANNOT be tested in iOS Simulator.

- Simulator: Can only test UI layout and state management
- Physical device: Required for all volume button interaction testing
- See quickstart.md for device setup instructions

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Manual testing on physical device is REQUIRED per Constitution v1.1.0
- App Store submission strategy documented in quickstart.md (include on-screen buttons)
