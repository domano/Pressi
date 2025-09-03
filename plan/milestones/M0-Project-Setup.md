# M0 — Project Setup

Scope: Initialize project targets, dependencies, signing, and basic build/test scaffolding.

Tickets
- PRS-001 Setup targets and platforms
  - Outcome: iOS/iPadOS app target “Pressi” set to iOS/iPadOS 18; bundle IDs and entitlements configured.
  - Acceptance: Project builds and runs on simulator; app launches to placeholder UI.
  - Dependencies: None
  - Estimate: S

- PRS-002 SPM dependencies scaffold
  - Outcome: Project groups for Engine, UI, Extensions, Tests; placeholders for SPM packages if needed.
  - Acceptance: Build graph compiles with empty modules and unit test target present.
  - Dependencies: PRS-001
  - Estimate: S

- PRS-003 Code signing & schemes
  - Outcome: Per-developer signing; Debug/Release schemes; extension build settings ready.
  - Acceptance: Clean builds for app and extension targets (placeholders) succeed.
  - Dependencies: PRS-001
  - Estimate: S

- PRS-004 CI bootstrap (optional)
  - Outcome: Scripted `xcodebuild` for build/test; optional CI workflow file.
  - Acceptance: Local script runs; CI job green on main.
  - Dependencies: PRS-001, PRS-003
  - Estimate: S
