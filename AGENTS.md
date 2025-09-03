# Repository Guidelines

## Project Structure & Module Organization
- `Pressi/`: App source (SwiftUI views, models, assets, `Info.plist`, entitlements).
- `PressiTests/`: Unit tests using Swift Testing (`import Testing`, `@Test`).
- `PressiUITests/`: UI tests using XCTest/XCUITest.
- `Pressi.xcodeproj`: Xcode project and schemes.
- `plan/`: Planning docs (milestones, risks, tickets) — not shipped.

## Build, Test, and Development Commands
- Open in Xcode: `open Pressi.xcodeproj`
- Build (CLI): `xcodebuild -project Pressi.xcodeproj -scheme Pressi -destination 'platform=iOS Simulator,name=iPhone 15' build`
- Run tests: `xcodebuild -project Pressi.xcodeproj -scheme Pressi -destination 'platform=iOS Simulator,name=iPhone 15' test`
- Focus UI tests: append `-only-testing:PressiUITests` (or a specific test).
Use Xcode’s Product > Build/Test for day‑to‑day development.

## Coding Style & Naming Conventions
- Swift 5.x, 4‑space indentation, target ~120‑column lines.
- Types/Enums/Protocols: UpperCamelCase; methods/properties: lowerCamelCase.
- File naming: one primary type per file (e.g., `Item.swift`, `ContentView.swift`).
- Prefer value types (`struct`), avoid force unwraps, mark `final` where appropriate.
- Formatting: use Xcode “Editor > Structure > Re‑Indent”. No lint tool is tracked in this repo.

## Testing Guidelines
- Unit tests live in `PressiTests/` with Swift Testing, e.g.:
  `@Test func example() { /* #expect(...) */ }`
- UI tests live in `PressiUITests/` with XCTest/XCUITest.
- Name tests descriptively: `test_feature_behavior_whenCondition`.
- Aim for meaningful coverage of view models and pure logic; keep UI tests stable (avoid brittle identifiers).

## Commit & Pull Request Guidelines
- Commits: imperative mood, concise subject (≤50 chars), details in body explaining what/why and any side effects. Reference issues (e.g., `Fixes #12`).
- Example:
  `Add Item model and basic ContentView list rendering`

- Pull Requests should include:
  - Clear summary and rationale; link related issues.
  - Screenshots or screen recordings for UI changes.
  - Test plan (commands run, simulators/devices used).
  - Small, focused diffs that build and pass tests locally.

## Security & Configuration Tips
- Do not commit secrets or keys; prefer build settings or per‑user configs.
- Capabilities are managed via `Pressi.entitlements`; edit in Xcode, review diffs carefully.

## Agent Workflow & Memory
- Source of truth: milestone specs in `plan/milestones/` derived from `PRD.docx` and `llm.txt`.
- Working memory: always update `plan/memory/LAST_MEMORY.md` at the end of each task with:
  - What was done, decisions made, files touched, and rationale.
  - Links/paths to relevant code and plan docs needed for the next task.
  - The proposed next task (milestone/ticket) and any open questions.
- Startup routine: before starting work, read `plan/memory/LAST_MEMORY.md` to restore context, then open the next milestone/ticket in `plan/`.
- Build/test: prefer the scripts `scripts/build.sh` and `scripts/test.sh` (or the `xcodebuild` commands listed above).
- Always run a clean build (and tests when applicable) immediately after completing changes. Consider a task done only after a successful build (and green tests).
- Commit after verification: After each working session, once the build and tests are green and you have updated memory (`plan/memory/LAST_MEMORY.md`) and any relevant documentation, commit the changes. Use a single, focused commit that follows the commit message guidelines above and references related tickets (e.g., `Implement PRS-014 theming; update docs/memory`).
- Docs updates when tests change behavior: If fixing or updating tests reveals or introduces a significant behavior change (user-visible flows, APIs, acceptance criteria), update the relevant docs in the same session. Prioritize `plan/architecture.md`, the milestone ticket(s) under `plan/milestones/` (acceptance sections), and any other affected docs. Keep tests, code, and docs in sync.
- LAST_MEMORY compaction: Keep `plan/memory/LAST_MEMORY.md` concise and focused on the latest sessions. When it becomes long (e.g., >200 lines) or at milestone boundaries, move older sections into separate, dated files under `plan/memory/` (e.g., `2025-09-04-PRS-021-engine-abstraction.md`). Leave a brief summary and links in `LAST_MEMORY.md` and retain the current "Open Questions / Next Steps" and the latest "Build/Test Verification".
- Don’t delete or weaken tests to go green: Never remove, skip, or water down tests solely to make CI pass. If tests fail, fix the code or adjust tests only when behavior is intentionally changed, and document the rationale in memory/docs. Keep tests as the source of truth for expected behavior.

- General memories: save noteworthy context as separate files under `plan/memory/` with descriptive names (e.g., `2025-09-04-PRS-013-error-model.md`) in addition to updating `LAST_MEMORY.md`.
- Always parse on task start: read `PRD.docx`, `llm.txt`, and `plan/memory/LAST_MEMORY.md` to ensure current requirements and context are applied.
- “Do the next task”: when prompted to continue, consult `plan/memory/LAST_MEMORY.md` to select the next milestone/ticket from `plan/` and proceed accordingly.

## M0 — Project Setup Status
- PRS-001 Targets & platforms: App target present (`Pressi`), iOS/iPadOS 18; placeholder UI in `ContentView.swift` launches via `PressiApp.swift`.
- PRS-002 Module scaffold: Engine (`Pressi/Engine/EngineCore.swift`), UI, Extensions (`Pressi/Extensions/ActionExtension`), and test targets exist; project compiles with placeholders.
- PRS-003 Schemes & signing: Shared scheme `Pressi` exists; extension Info.plist scaffold present. Per‑developer signing expected via Xcode (verify locally).
- PRS-004 CI bootstrap (optional): Local scripts present (`scripts/build.sh`, `scripts/test.sh`). Add CI workflow later as needed.

Conclusion: M0 appears complete pending local signing verification by each developer. Proceed to M1 once clean build/test succeeds locally.
