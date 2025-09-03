# M9 — Testing & Quality

Scope: Unit/UI/performance tests, edge cases, and reliability.

Tickets
- PRS-090 Unit tests
  - Outcome: Engine tests for formats, passwords, corrupt archives, large files.
  - Acceptance: CI green; coverage targets met for engine.
  - Dependencies: M2
  - Estimate: M

- PRS-091 UI tests
  - Outcome: Share sheet flows, in-app compress/extract, settings persistence, iPad layouts.
  - Acceptance: Tests pass on iPhone/iPad simulators.
  - Dependencies: M3, M4, M5
  - Estimate: M

- PRS-092 Performance tests
  - Outcome: Benchmarks for 100 MB and 1 GB scenarios with targets for duration and memory.
  - Acceptance: Results documented; regressions tracked.
  - Dependencies: PRS-022..026
  - Estimate: M

- PRS-093 Crash/edge cases
  - Outcome: Handling for low disk space, interruption, unicode/long paths, and partial failures.
  - Acceptance: Tests or manual QA cases documented and verified.
  - Dependencies: M2, M3
  - Estimate: S
