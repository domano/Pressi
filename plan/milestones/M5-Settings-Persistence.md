# M5 — Settings & Persistence

Scope: Defaults for format/level/location/theme; settings UI; persistence; integration with extensions.

Tickets
- PRS-050 Defaults
  - Outcome: Default format, compression level, extraction location, and theme; persisted via UserDefaults/AppStorage.
  - Acceptance: Values persist across sessions; accessible from extension flows.
  - Dependencies: PRS-012
  - Estimate: S

- PRS-051 Settings UI
  - Outcome: SwiftUI form for settings with inline help.
  - Acceptance: Changes reflected immediately; validation for locations.
  - Dependencies: PRS-050
  - Estimate: S

- PRS-052 Integration defaults
  - Outcome: Extension flows use defaults unless overridden.
  - Acceptance: Share sheet actions honor settings by default.
  - Dependencies: PRS-050, PRS-030..032
  - Estimate: S

- PRS-053 Storage permissions
  - Outcome: Security-scoped bookmarks for default locations; robust error handling.
  - Acceptance: Extraction to default location works after relaunch; errors surfaced clearly.
  - Dependencies: PRS-050
  - Estimate: M
