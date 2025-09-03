# Agent Working Memory — Last Session (Compact)

## Current Snapshot (2025-09-04)
- Milestone: M2 — Compression/Decompression Engine.
- Completed: PRS-021 Engine abstraction (`ArchiveService`, `EngineRunner` integrated into `JobsStore`). PRS-022 minimal ZIP (store-only) roundtrip.
- Recent: PRS-014 theming tokens applied to UI; PRS-013 error model and alert flow wired.
- Docs: AGENTS.md updated (commit-after-green; docs-on-test-change; LAST_MEMORY compaction).

## Open Questions / Next Steps
- PRS-022: Implement ZIP end-to-end behind `ArchiveService`; begin wiring real input/output URLs via `JobsStore`.
- Finalize error/reporting hooks when real Engine errors are known (PRS-025).
- Validate theming with Accessibility Inspector on XL/XXL sizes.
- Plan performance and streaming IO work (PRS-026); password flows (PRS-025); detection (PRS-027).

## Build/Test Verification (2025-09-04, post-PRS-021)
- Ran `./scripts/build.sh` — success.
- Ran `./scripts/test.sh` — success (all tests passed on iPhone 16 Pro simulator).

## PRS-022 — ZIP End-to-End (minimal) (2025-09-04)
- Implemented basic ZIP create/extract (store-only) in `DefaultArchiveService` with CRC32, local headers, and central directory; naive extraction parser.
- Added unit tests at `PressiTests/EngineZipTests.swift` for single-file and multi-file roundtrip.
- Fixed little-endian readers for robust parsing; validated via focused run `-only-testing:PressiTests` where 3 Swift Testing cases pass.
- Note: `scripts/test.sh` output summarizes XCTest suites; Swift Testing prints its own summary. Focused run confirms unit tests execute and pass.
- AGENTS.md updated with policy: do not delete or weaken tests to go green; fix code or adjust tests only when behavior changes, and document.

## Archived Sections
- M0/M1 setup & architecture, build fix, early verification: plan/memory/2025-09-04-M0-M1-setup-and-arch.md
- PRS-013 — Error Model: plan/memory/2025-09-04-PRS-013-error-model.md
- PRS-014 — Theming & Typography: plan/memory/2025-09-04-PRS-014-theming.md
- Docs/Policy updates: plan/memory/2025-09-04-Docs-Policy-Updates.md
