# M1 — Architecture & UI Skeleton

Scope: Establish module boundaries, SwiftUI navigation, state containers, error model, and theming.

Tickets
- PRS-010 App architecture foundation
  - Outcome: Defined modules (Engine, UI, Extensions) and data flow with EnvironmentObject for settings/state.
  - Acceptance: Documented architecture diagram; compiles with stubs.
  - Dependencies: M0
  - Estimate: S

- PRS-011 Navigation skeleton
  - Outcome: Root SwiftUI navigation (Home, Settings) with placeholder views and routing.
  - Acceptance: Navigable app on simulator; no runtime warnings.
  - Dependencies: PRS-010
  - Estimate: S

- PRS-012 State containers
  - Outcome: `SettingsStore` (@StateObject), `JobsStore` (progress, cancellation), DI points.
  - Acceptance: Stores wired to views; preview builds.
  - Dependencies: PRS-011
  - Estimate: M

- PRS-013 Error/reporting model
  - Outcome: Standard error types (user vs. dev), cancellation types, and retry patterns.
  - Acceptance: Sample flows present errors with user-friendly messages.
  - Dependencies: PRS-012
  - Estimate: S

- PRS-014 Theming & typography
  - Outcome: System color schemes, Dynamic Type support, base styles.
  - Acceptance: Verified via Accessibility Inspector; no clipped text on XL sizes.
  - Dependencies: PRS-011
  - Estimate: S
