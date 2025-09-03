# M2 — Compression/Decompression Engine

Scope: Select libraries, define engine abstraction, implement formats, passwords, performance, and detection.

Tickets
- PRS-020 Spike: archive libraries
  - Outcome: Recommendation (e.g., libarchive, ZIPFoundation combo) for App Store compliance, encryption, 7z.
  - Acceptance: Decision doc with trade-offs and PoC results.
  - Dependencies: M1
  - Estimate: M

- PRS-021 Engine abstraction
  - Outcome: `ArchiveService` protocol: list, compress(format, level, password), extract(selection, destination, password) with async progress & cancel.
  - Acceptance: Protocol + default impl stubs; progress publisher/callbacks defined.
  - Dependencies: PRS-020
  - Estimate: M

- PRS-022 Implement ZIP end-to-end
  - Outcome: ZIP create/extract, levels, AES-256 encryption if supported; tests.
  - Acceptance: Unit tests pass for ZIP including passworded archives and cancel.
  - Dependencies: PRS-021
  - Estimate: M

- PRS-023 Implement TAR family
  - Outcome: TAR, TAR.GZ, TAR.BZ2, TAR.XZ creation/extraction with auto-detection.
  - Acceptance: Unit tests for create/extract and detection; streaming IO verified.
  - Dependencies: PRS-021
  - Estimate: M

- PRS-024 Implement 7z read/write
  - Outcome: 7z extraction (and creation if feasible); documented limits.
  - Acceptance: Unit tests for 7z read; write covered or deferred with note.
  - Dependencies: PRS-021, PRS-020
  - Estimate: M/L

- PRS-025 Password prompts & errors
  - Outcome: Standard password-required/incorrect handling; error mapping.
  - Acceptance: Tests cover wrong password, missing password, and retry.
  - Dependencies: PRS-022..024
  - Estimate: S

- PRS-026 Performance & large files
  - Outcome: Streamed IO; memory guardrails; measure with 100 MB–1 GB samples.
  - Acceptance: Performance report; cancels within 300 ms; memory stays bounded.
  - Dependencies: PRS-022..024
  - Estimate: M

- PRS-027 File type detection
  - Outcome: Magic/extension detection with robust fallbacks; metadata capture.
  - Acceptance: Tests for ambiguous and mixed extensions; correct detection rate.
  - Dependencies: PRS-021
  - Estimate: S
