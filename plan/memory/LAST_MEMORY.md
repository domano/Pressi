# Agent Working Memory — Last Session

- Milestone: M0 — Project Setup (verification)
- Sources reviewed: 
  - plan/milestones/M0-Project-Setup.md
  - PRD.docx (extracted text)
  - llm.txt
- Outcome: M0 considered complete based on repository state; proceed to M1 after local build/signing verification.

## What I Did
- Validated presence of app target and placeholder UI (`Pressi/PressiApp.swift`, `Pressi/ContentView.swift`).
- Confirmed scaffolding for modules and tests:
  - Engine stub at `Pressi/Engine/EngineCore.swift`.
  - Action Extension scaffold at `Pressi/Extensions/ActionExtension/`.
  - Unit tests in `PressiTests/`, UI tests in `PressiUITests/`.
- Checked build/test scripts: `scripts/build.sh`, `scripts/test.sh`.
- Reviewed `Pressi.xcodeproj` for shared scheme (`Pressi`).

## Decisions & Notes
- PRS-001 (targets/platforms): Satisfied — simulator‑runnable skeleton present.
- PRS-002 (SPM/module scaffold): Satisfied — placeholders compile conceptually; no external SPM deps needed yet.
- PRS-003 (schemes/signing): Scheme present; per‑developer signing must be verified locally in Xcode.
- PRS-004 (CI bootstrap): Local scripts present; CI workflow can be added later.

## Next Task Proposal
- Milestone: M1 — Architecture & UI Skeleton.
- Completed in this session: PRS-010 (architecture foundation) and PRS-011 (navigation skeleton).
- Next up: PRS-012 (State containers integration with engine), PRS-013 (error model), PRS-014 (theming).
- Prereq: Run a clean local build/test to confirm signing and simulator configuration.

## Pointers for Next Session
- Read: `plan/milestones/M1-Architecture-UI-Skeleton.md` and `plan/architecture.md`.
- Code entry points: `PressiApp.swift`, `Pressi/UI/RootView.swift`, stores in `Pressi/AppState/`.
- Where to document: update `AGENTS.md` if architecture conventions evolve; keep this memory file updated with key decisions.

## What I Did (M1)
- Added app state containers:
  - `Pressi/AppState/SettingsStore.swift` (defaults, compression level)
  - `Pressi/AppState/JobsStore.swift` (job list, progress, cancellation, `JobRunner` abstraction with `SimulatedRunner`)
- Added root navigation and views:
  - `Pressi/UI/RootView.swift` with TabView (Home, Settings) and jobs overlay strip
  - `HomeView` quick actions now call `jobs.start(...)` to launch simulated jobs
  - Jobs overlay shows a cancel button per in‑flight job
  - `SettingsView` bound to `SettingsStore`
- Wired environment objects in `Pressi/PressiApp.swift` and set root to `RootView()`.
- Wrote `plan/architecture.md` summarizing modules, state flow, and next steps.

### Build Fix (2025-09-04)
- Resolved compile errors in `JobsStore.swift`:
  - Removed `public` access and `@MainActor` from `JobRunner`/`SimulatedRunner` to avoid visibility and actor-isolation issues.
- Changed default runner and execution to run off the main actor via `Task.detached`; post progress by spawning a nested `Task { await MainActor.run { ... } }` to keep the `onProgress` closure synchronous.
- Added cancellation checks in `SimulatedRunner` loop.
 - Addressed Swift 6 capture rules: captured `runner` and `jobID` outside detached Task; annotated `onProgress` as `@Sendable`; used `Task { @MainActor ... }` for UI updates.

## Open Questions / Next Steps
- Replace `SimulatedRunner` with Engine-backed runner that performs real compression/decompression.
- Finalize error/reporting hooks once Engine errors are known.
- Validate theming with Accessibility Inspector on XL/XXL sizes.

## Build/Test Verification (2025-09-04)
- Ran `./scripts/build.sh` — success.
- Ran `./scripts/test.sh` — all tests passed.
- Proceed with PRS-013 (error model) next.

## PRS-014 — Theming & Typography (2025-09-04)
- Added base theming tokens at `Pressi/UI/Theme/AppTheme.swift`.
- Colors: `AppTheme.Palette` (accent/background/textPrimary/textSecondary/etc.) use system-aware dynamic colors.
- Typography: `AppTheme.Typography` provides semantic fonts (largeTitle/title/headline/body/caption/footnote).
- Applied tokens in `RootView`:
  - Global `.tint(AppTheme.Palette.accent)` for consistent control tint.
  - Jobs strip uses `Typography.caption` and `Palette.textSecondary` with `minimumScaleFactor(0.8)` for better Dynamic Type behavior.
  - Defaults rows use `Palette.textSecondary` for value text.
- Updated `plan/architecture.md` Theming section to document usage.

### Proposed Next Task
- Milestone: M2 — Compression Engine.
- Tickets to start: define Engine runner and integrate with `JobsStore` (replace `SimulatedRunner`), add basic archive operations per PRD.

## PRS-013 — Error Model (2025-09-04)
- Added `Pressi/AppState/AppError.swift` with `PressiError` (user/developer/cancelled) and `PresentedError` for UI.
- Updated `JobRunner` to `async throws`; `SimulatedRunner` now throws a user error when the job name contains "fail" (for demo/testing).
- `JobsStore` catches errors, marks job state, and sets `presentedError` for UI.
- `RootView` shows an alert via `.alert(item: $jobs.presentedError)`; Home adds a "Start Failing Job" button to demonstrate.
- Architecture doc updated to reflect error flow.
