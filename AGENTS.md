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
