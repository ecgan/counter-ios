# Feature Specification: Counter iOS App with Volume Button Control

**Feature Branch**: `feature/init-spec-kit`
**Created**: 2026-01-14
**Status**: Draft
**Input**: User description: "Develop Counter, a counter mobile app. The main feature for this app is that you can increment and decrement by pressing the volume up and down button. Users can press both buttons together to reset the counter. This should primarily be an iOS app."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Increment Counter with Volume Up (Priority: P1)

As a user, I want to press the physical volume up button to increment the counter by 1, so that I can count items quickly without looking at my phone screen.

**Why this priority**: This is the core functionality that differentiates this app from standard counter apps. The hands-free counting capability is the primary value proposition.

**Independent Test**: Can be fully tested by pressing the volume up button and verifying the counter display increases by 1. Delivers immediate value as a basic counting tool.

**Acceptance Scenarios**:

1. **Given** the app is open and the counter shows 0, **When** I press the volume up button once, **Then** the counter displays 1
2. **Given** the app is open and the counter shows 42, **When** I press the volume up button once, **Then** the counter displays 43
3. **Given** the app is in the foreground, **When** I press volume up, **Then** the system volume does not change (only counter increments)

---

### User Story 2 - Decrement Counter with Volume Down (Priority: P2)

As a user, I want to press the physical volume down button to decrement the counter by 1, so that I can correct counting mistakes without touching the screen.

**Why this priority**: Decrementing completes the basic counting functionality and allows users to correct errors, which is essential for accurate counting.

**Independent Test**: Can be fully tested by pressing the volume down button and verifying the counter display decreases by 1. Combined with increment, provides a complete counting tool.

**Acceptance Scenarios**:

1. **Given** the app is open and the counter shows 5, **When** I press the volume down button once, **Then** the counter displays 4
2. **Given** the app is open and the counter shows 0, **When** I press the volume down button once, **Then** the counter displays -1 (allows negative numbers)
3. **Given** the app is in the foreground, **When** I press volume down, **Then** the system volume does not change (only counter decrements)

---

### User Story 3 - Reset Counter with On-Screen Button (Priority: P3)

As a user, I want to tap an on-screen Reset button to reset the counter to 0, so that I can quickly start a new count.

**Why this priority**: Reset functionality is important but less frequently used than increment/decrement. An on-screen button provides reliable, accessible reset capability.

**Design Decision**: Volume-based reset (pressing both buttons simultaneously) was not feasible due to iOS hardware limitations—simultaneous volume button presses cancel each other out at the hardware level, preventing reliable detection.

**Independent Test**: Can be fully tested by tapping the on-screen Reset button and verifying the counter resets to 0. Provides reliable reset capability.

**Acceptance Scenarios**:

1. **Given** the app is open and the counter shows 50, **When** I tap the Reset button, **Then** the counter resets to 0
2. **Given** the app is open and the counter shows -10, **When** I tap the Reset button, **Then** the counter resets to 0
3. **Given** I tap the Reset button, **When** the reset occurs, **Then** haptic feedback confirms the action

---

### User Story 4 - View Current Count (Priority: P1)

As a user, I want to see the current count displayed prominently on screen, so that I can easily read the count at a glance.

**Why this priority**: Displaying the count is fundamental to the app's purpose. Without a visible count, the app provides no feedback.

**Independent Test**: Can be fully tested by opening the app and verifying a large, readable counter is displayed. Essential for any counting functionality.

**Acceptance Scenarios**:

1. **Given** I open the app for the first time, **When** the app loads, **Then** I see the counter displayed as 0
2. **Given** the counter value is 999, **When** I look at the screen, **Then** the number is clearly readable from arm's length
3. **Given** the app is in any state, **When** I view the display, **Then** the current count is always visible

---

### Edge Cases

- What happens when the user holds down a volume button continuously? The counter should increment/decrement repeatedly at 150ms intervals (~6 counts per second).
- How does the system handle extremely large numbers? The counter should support at least 6-digit numbers (up to 999,999) without display issues.
- What happens if the app is in the background? Volume buttons should control system volume normally; counter changes only occur when app is in foreground.
- What happens on app restart? The counter should persist its last value between app sessions.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST increment the counter by 1 when the volume up button is pressed while the app is in the foreground
- **FR-002**: System MUST decrement the counter by 1 when the volume down button is pressed while the app is in the foreground
- **FR-003**: System MUST reset the counter to 0 when the user taps the on-screen Reset button
- **FR-004**: System MUST display the current counter value prominently on the main screen
- **FR-005**: System MUST intercept volume button presses to prevent system volume changes while the app is in the foreground
- **FR-006**: System MUST persist the counter value between app sessions using UserDefaults (survives app close and restart)
- **FR-007**: System MUST support negative counter values
- **FR-008**: System MUST debounce rapid button presses with a 150ms delay between registered presses (allows ~6 counts per second)
- **FR-009**: System MUST restore normal volume button behavior when the app moves to background

### Key Entities

- **Counter**: Represents the current count value. Attributes: current value (integer), last updated timestamp. Persists across sessions.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can increment/decrement the counter without touching the screen 100% of the time when the app is in the foreground
- **SC-002**: Counter value is readable from 60cm (arm's length) away in normal lighting conditions
- **SC-003**: Button press to counter update takes less than 100ms (feels instantaneous)
- **SC-004**: Counter value persists correctly across 100% of app restarts
- **SC-005**: Users can complete a count of 100 items in under 2 minutes using volume buttons
- **SC-006**: Reset action (on-screen button) works successfully on first attempt 100% of the time

## Clarifications

### Session 2026-01-14

- Q: What debounce timing should be used for volume button presses? → A: 150ms (fast - allows ~6 counts per second)
- Q: Which persistence approach should be used for counter storage? → A: UserDefaults (simple key-value storage)
- Q: Which UI framework should be used for building the app? → A: SwiftUI (modern declarative UI)

## Assumptions

- The app is built using SwiftUI as the UI framework
- The app runs on iOS 15.0 or later
- The device has physical volume buttons (not applicable to iPod touch without buttons)
- Users have basic familiarity with their iPhone's volume buttons
- The app will be used primarily for counting discrete items or events
- Negative counting is a valid use case (e.g., tracking inventory changes)
