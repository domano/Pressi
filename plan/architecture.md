# Architecture Overview

Scope: Baseline app architecture for Pressi (M1 — PRS-010/PRS-011).

## Modules
- Engine: Core compression/decompression logic and adapters (see `Pressi/Engine/ArchiveService.swift`, `EngineRunner.swift`, and stub `EngineCore.swift`).
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
- Use `PressiError` to distinguish user‑facing vs developer errors and cancellation.
- Jobs are executed via a `JobRunner` that can throw; `JobsStore` catches and exposes `presentedError` for UI alerts.
- UI presents friendly alert messages; developer/unknown errors map to a generic message.

## Theming
- Base tokens live in `Pressi/UI/Theme/AppTheme.swift`.
- Palette: `AppTheme.Palette` wraps system-aware colors (accent/background/textPrimary/textSecondary).
- Typography: `AppTheme.Typography` exposes semantic fonts (e.g., `caption`, `body`, `headline`).
- Views should prefer tokens for color and font to ensure consistency and Dynamic Type support.

## Next Steps
- PRS-022+: Implement real ZIP/TAR/7z operations behind `ArchiveService`.
- PRS-025: Standardize password prompts and error mapping.
- PRS-026: Streamed IO and performance work.
