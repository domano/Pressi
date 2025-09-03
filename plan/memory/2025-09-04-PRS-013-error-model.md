# Archive: PRS-013 — Error Model (2025-09-04)

- Added `Pressi/AppState/AppError.swift` with `PressiError` (user/developer/cancelled) and `PresentedError` for UI.
- Updated `JobRunner` to `async throws`; `SimulatedRunner` now throws a user error when the job name contains "fail" (for demo/testing).
- `JobsStore` catches errors, marks job state, and sets `presentedError` for UI.
- `RootView` shows an alert via `.alert(item: $jobs.presentedError)`; Home adds a "Start Failing Job" button to demonstrate.
- Architecture doc updated to reflect error flow.

