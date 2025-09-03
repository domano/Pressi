# Project Plan

This folder contains the milestone-based project plan and ticket breakdown for the iOS/iPadOS archiver app (working name: Pressi). The plan is derived from PRD.docx and llm.txt.

## Structure
- `milestones/`: One file per milestone with scoped tickets (PRS-xxx).
- `tickets/template.md`: Ticket template for new work items.
- `risks.md`: Assumptions, risks, and mitigations.

## Milestones Overview
- M0 — Project Setup
- M1 — Architecture & UI Skeleton
- M2 — Compression/Decompression Engine
- M3 — Share Sheet Actions (Extensions)
- M4 — App UI (In‑App Flows)
- M5 — Settings & Persistence
- M6 — Files Integration
- M7 — Accessibility & Localization
- M8 — Security & Privacy
- M9 — Testing & Quality
- M10 — Release Prep

## Notes
- Platforms: iOS 18 / iPadOS 18; Swift 5.9+; SwiftUI 5.
- Core goals: wide format support (ZIP, 7z, TAR, GZ, BZ2, XZ), encryption, progress/cancel, deep share sheet/Files integration.
- Use this plan to create issues/milestones in your PM tool or repo.
