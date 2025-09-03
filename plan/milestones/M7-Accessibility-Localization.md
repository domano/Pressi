# M7 — Accessibility & Localization

Scope: VoiceOver, Dynamic Type, high contrast/motion, and localization.

Tickets
- PRS-070 Accessibility
  - Outcome: All controls have labels/traits; Dynamic Type verified; hit targets sized.
  - Acceptance: VoiceOver usable flows; Accessibility Inspector checks pass.
  - Dependencies: M3, M4
  - Estimate: S

- PRS-071 Localization
  - Outcome: English baseline, add German; Localizable.strings and RTL checks.
  - Acceptance: Strings externalized; German build verified; layout holds for longer strings.
  - Dependencies: PRS-070
  - Estimate: S

- PRS-072 High contrast & motion
  - Outcome: Respects increased contrast and reduce motion settings; progress animations accessible.
  - Acceptance: Visual checks in Settings accessibility modes.
  - Dependencies: PRS-070
  - Estimate: S
