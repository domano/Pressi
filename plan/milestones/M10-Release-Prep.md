# M10 — Release Prep

Scope: Branding, store assets, licenses, distribution, and submission.

Tickets
- PRS-100 App icon and branding
  - Outcome: Final name vs. working name; icon and colors; marketing assets.
  - Acceptance: App uses final assets; screenshots reflect brand.
  - Dependencies: None
  - Estimate: S

- PRS-101 App Store assets
  - Outcome: Store screenshots (phone/tablet), description, keywords, privacy manifest.
  - Acceptance: App Store Connect metadata complete; validation passes.
  - Dependencies: PRS-100
  - Estimate: S

- PRS-102 Third-party notices
  - Outcome: License acknowledgements for libraries (e.g., libarchive/ZIPFoundation).
  - Acceptance: Notices present in app and repository.
  - Dependencies: None
  - Estimate: S

- PRS-103 Beta distribution
  - Outcome: TestFlight build, release notes, feedback capture loop.
  - Acceptance: External testers onboarded; feedback channel active.
  - Dependencies: PRS-101
  - Estimate: S

- PRS-104 1.0 checklist
  - Outcome: Final regression, store submission, and post-launch monitoring plan.
  - Acceptance: App submitted; monitoring in place.
  - Dependencies: PRS-101..103
  - Estimate: S
