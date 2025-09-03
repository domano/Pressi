# M6 — Files Integration

Scope: Context menus, archive browsing feasibility, and optional preview integration.

Tickets
- PRS-060 Spike: File Provider Extension feasibility
  - Outcome: Analysis of browsing archives as a Files location vs. in-app preview.
  - Acceptance: Decision doc with scope/cost and recommendation for MVP.
  - Dependencies: M2
  - Estimate: S

- PRS-061 Archive browsing MVP
  - Outcome: Read-only browse of archive contents (extension or in-app fallback).
  - Acceptance: User can inspect entries and extract selected items.
  - Dependencies: PRS-060, PRS-024
  - Estimate: M

- PRS-062 Context menus in Files
  - Outcome: “Compress with Pressi” and “Extract with Pressi” appear for supported types.
  - Acceptance: Long-press in Files shows actions; launch extensions successfully.
  - Dependencies: PRS-030..032
  - Estimate: S

- PRS-063 Quick Look (optional)
  - Outcome: QLPreview to show archive structure.
  - Acceptance: Preview available for common formats; performance acceptable.
  - Dependencies: PRS-061
  - Estimate: S
