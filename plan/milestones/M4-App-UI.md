# M4 — App UI (In‑App Flows)

Scope: Provide in-app compress/extract flows, jobs list, and iPad adaptations.

Tickets
- PRS-040 Home quick actions
  - Outcome: Home with quick actions (New Archive, Extract Archive), recent jobs, share sheet tips.
  - Acceptance: Actions launch flows; recent jobs display with statuses.
  - Dependencies: M1, M2
  - Estimate: M

- PRS-041 New Archive flow
  - Outcome: File picker integration; format/level/password options; progress; export/share result.
  - Acceptance: Create ZIP/others in-app; share/export succeeds; cancel works.
  - Dependencies: PRS-022..023, PRS-021
  - Estimate: M

- PRS-042 Extract Archive flow
  - Outcome: File picker for archives; preview entries; selective extraction; progress; open in Files.
  - Acceptance: Extracts selection to destination; opens destination; handles password.
  - Dependencies: PRS-022..024
  - Estimate: M

- PRS-043 Jobs history
  - Outcome: List of operations with status, sizes, durations, error logs; retry/open destination.
  - Acceptance: Jobs persist for recent sessions; actions function.
  - Dependencies: PRS-012
  - Estimate: S

- PRS-044 iPad layout
  - Outcome: Adaptive layout with split view; keyboard shortcuts for actions.
  - Acceptance: Verified on iPad simulator; shortcuts documented.
  - Dependencies: PRS-040..043
  - Estimate: S
