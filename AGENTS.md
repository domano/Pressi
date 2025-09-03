# Repository Guidelines

## Project Structure & Module Organization
- `Pressi/`: SwiftUI app source (entry `PressiApp.swift`, root view `ContentView.swift`, models like `Item.swift`, assets in `Assets.xcassets`, config in `Info.plist`, entitlements in `Pressi.entitlements`).
- `PressiTests/`: Unit tests (XCTest).
- `PressiUITests/`: UI tests (XCTest UI harness).
- `Pressi.xcodeproj/`: Xcode project and schemes.
- Docs & assets: `Wireframes for app features.pdf`, `llm.txt` (planning/notes).

## Build, Test, and Development Commands
- Open in Xcode: `open Pressi.xcodeproj`
- Build (CLI): `xcodebuild -project Pressi.xcodeproj -scheme Pressi build`
- Run tests (CLI): `xcodebuild -project Pressi.xcodeproj -scheme Pressi -destination 'platform=iOS Simulator,name=iPhone 15' test`
- Preferred workflow: build/run from Xcode, select the "Pressi" scheme and a simulator.

## Coding Style & Naming Conventions
- Indentation: 4 spaces; keep lines < 120 chars.
- Swift style: types `UpperCamelCase`, variables/functions `lowerCamelCase`, constants `lowerCamelCase`.
- Files: one primary type per file; name files after the type (e.g., `Item.swift`).
- SwiftUI: suffix views with `View` (e.g., `HomeView`); view models with `ViewModel`.
- Imports: keep minimal; favor struct/value types; prefer `private` by default.

## Testing Guidelines
- Framework: XCTest for unit and UI tests.
- Location: unit tests in `PressiTests/`, UI tests in `PressiUITests/`.
- Naming: test files mirror target (`ItemTests.swift`), methods `test_<behavior>()`.
- Coverage: add tests for new logic; update affected tests with behavior changes.
- Run: from Xcode (Product → Test) or the `xcodebuild ... test` command above.

## Commit & Pull Request Guidelines
- Commits: imperative, concise subject (<= 72 chars), detailed body when needed.
  - Examples: `Add Item model decoding`, `Fix ContentView empty state layout`.
- PRs: clear description, link issues, list changes, include screenshots for UI, and a brief test plan.
- Keep changes scoped; update docs and tests alongside code.

## Security & Configuration Tips
- Do not commit signing certificates, provisioning profiles, or secrets.
- App settings live in `Info.plist` and `Pressi.entitlements`; document any key you add.
- Use per-developer signing; match bundle IDs to your team when running locally.
