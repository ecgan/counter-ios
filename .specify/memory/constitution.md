<!--
SYNC IMPACT REPORT
==================
Version change: 1.0.0 → 1.1.0
Modified principles:
  - Code Quality: Removed mandatory testing requirement
  - Quality Gates: Removed automated test gate
  - Development Workflow: Testing made optional, manual testing preferred
Added sections: None
Removed sections: None
Templates requiring updates:
  - .specify/templates/plan-template.md: ✅ Compatible
  - .specify/templates/spec-template.md: ✅ Compatible
  - .specify/templates/tasks-template.md: ✅ Compatible (tests already marked optional)
Follow-up TODOs: None
-->

# Counter App Constitution

## Core Principles

### I. Code Quality

All code contributions MUST adhere to strict quality standards to ensure maintainability and reliability.

- **Readability**: Code MUST be self-documenting with clear naming conventions; comments are reserved for explaining "why," not "what"
- **Single Responsibility**: Each function, class, or module MUST have one clearly defined purpose
- **Type Safety**: All code MUST use proper type annotations appropriate to the language (Swift types for iOS)
- **Error Handling**: All error paths MUST be explicitly handled; silent failures are prohibited

**Rationale**: A counter app relies on precise state management. Poor code quality leads to counting errors that destroy user trust.

### II. User Experience Consistency

The user interface and interaction patterns MUST provide a predictable, intuitive experience.

- **Immediate Feedback**: All user actions (button presses, volume rocker inputs) MUST produce visible feedback within 100ms
- **State Visibility**: Current count MUST always be clearly visible; state changes MUST be animated to show causality
- **Gesture Predictability**: Identical gestures MUST always produce identical outcomes; no context-dependent behavior changes
- **Accessibility**: All UI elements MUST support VoiceOver/accessibility features; count MUST be announced on change
- **Offline-First**: All core functionality MUST work without network connectivity

**Rationale**: Users depend on the counter in physical contexts (gyms, inventory, tally situations) where cognitive load must be minimal.

### III. Performance Requirements

The app MUST meet strict performance standards to ensure reliability during active use.

- **Response Time**: Volume button events MUST be processed and UI updated within 50ms
- **Battery Efficiency**: Background volume monitoring MUST NOT consume more than 1% battery per hour of active use
- **Memory Footprint**: App MUST NOT exceed 50MB memory during normal operation
- **Startup Time**: App MUST be fully interactive within 500ms of launch
- **State Persistence**: Count state MUST be persisted immediately; no data loss on app termination or crash

**Rationale**: A slow or unresponsive counter defeats its purpose. Users in counting scenarios cannot wait for laggy responses.

## Quality Gates

All code changes MUST pass the following gates before merge:

| Gate | Requirement | Enforcement |
|------|-------------|-------------|
| Build | Zero warnings, zero errors | CI automated |
| Performance | Response time benchmarks pass | Manual verification |
| Accessibility | VoiceOver audit passes | Manual review |
| Code Review | At least one approval required | GitHub PR rules |

## Development Workflow

### Code Review Requirements

- All changes MUST be submitted via pull request
- PRs MUST include description of changes and testing performed
- Performance-sensitive changes MUST include benchmark results
- UI changes MUST include screenshots or screen recordings

### Testing Protocol

- Manual testing is the primary validation method for rapid development
- Automated tests are OPTIONAL and can be added later as the project matures
- Critical user flows SHOULD be manually verified before each release

## Governance

This constitution represents the non-negotiable standards for the Counter app project.

- **Supremacy**: This constitution supersedes all other development practices and preferences
- **Amendment Process**: Changes require documented rationale, team review, and explicit approval
- **Compliance**: All pull requests and code reviews MUST verify adherence to these principles
- **Exceptions**: Any deviation MUST be documented in a Complexity Tracking table with justification

**Version**: 1.1.0 | **Ratified**: 2026-01-14 | **Last Amended**: 2026-01-14
