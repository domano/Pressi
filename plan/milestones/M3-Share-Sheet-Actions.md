# M3 — Share Sheet Actions (Extensions)

Scope: Create compress/extract action extensions with compact SwiftUI modals, progress, cancel, and error flows.

Tickets
- PRS-030 Extension targets
  - Outcome: “Compress with Pressi” and “Extract with Pressi” Action Extensions with correct NSExtensionActivationRule and UTTypes.
  - Acceptance: Extensions appear in share sheet for files and archives on simulator.
  - Dependencies: M0, M2
  - Estimate: S

- PRS-031 Compress UX
  - Outcome: Format picker, level slider, password field, destination chooser; progress & cancel.
  - Acceptance: Happy path compress via share sheet produces archive and share sheet to export.
  - Dependencies: PRS-030, PRS-022..023
  - Estimate: M

- PRS-032 Extract UX
  - Outcome: Password prompt, destination selection, selective extraction options.
  - Acceptance: Extracts to chosen folder; prompts for password when needed; supports subset selection.
  - Dependencies: PRS-030, PRS-022..024
  - Estimate: M

- PRS-033 Background safety
  - Outcome: Extensions handle time limits; degrade gracefully; suggest in-app continuation for long ops.
  - Acceptance: Simulated long task behavior verified; user messaging implemented.
  - Dependencies: PRS-031, PRS-032
  - Estimate: S

- PRS-034 Error handling
  - Outcome: Clear user errors, retry with password, partial failure reporting.
  - Acceptance: UI tests cover wrong password/cancel/partial failures.
  - Dependencies: PRS-031, PRS-032
  - Estimate: S

- PRS-035 Extension tests
  - Outcome: UI tests for share sheet compress/extract flows and cancellation.
  - Acceptance: Tests pass on iPhone and iPad simulators.
  - Dependencies: PRS-031..034
  - Estimate: M
