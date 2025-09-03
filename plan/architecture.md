# Architecture Overview

Scope: Baseline app architecture for Pressi (M1 — PRS-010/PRS-011).

## Modules
- Engine: Core compression/decompression logic and adapters (currently stubbed in `Pressi/Engine/EngineCore.swift`).
- UI: SwiftUI views, navigation, and state stores (`Pressi/UI`, `Pressi/AppState`).
- Extensions: Share/Action extensions (`Pressi/Extensions/ActionExtension`).

## App State & Data Flow
- SettingsStore (ObservableObject): app‑wide defaults — `defaultFormat`, `compressionLevel`, `encryptByDefault`.
- JobsStore (ObservableObject): tracks compression/decompression jobs with progress and cancellation. Uses a `JobRunner` abstraction; currently backed by `SimulatedRunner` that drives progress. Engine integration will replace the runner.
- Injection: Stores are created in `PressiApp` and injected via `.environmentObject(...)`.

## Navigation
- RootView: TabView with "Home" and "Settings" tabs.
- HomeView: quick actions and display of current defaults; shows active jobs overlay strip.
- SettingsView: form to edit defaults bound to `SettingsStore`.

## Error Model (stub)
- Distinguish user‑facing vs developer errors. For M1, use Swift Error enums in Engine and map to user messages in UI. (To be implemented in PRS-013.)

## Theming (stub)
- Use system colors/typography and Dynamic Type. Custom theme surface to be introduced later (PRS-014).

## Next Steps
- PRS-012: Introduce `JobsStore` integration with Engine operations and cancellation.
- PRS-013: Define error types and user messaging utilities.
- PRS-014: Establish base theming tokens and typography helpers.
