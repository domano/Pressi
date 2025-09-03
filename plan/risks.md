# Assumptions & Risks

Assumptions
- iOS/iPadOS 18 only; Swift 5.9+, SwiftUI 5.
- Share sheet extensions can complete typical archive operations within time limits for medium files.

Risks & Mitigations
- 7z write support: Some libraries have limited or no 7z creation support.
  - Mitigation: Launch with 7z extraction and document; explore creation if feasible.
- File Provider complexity: Browsing archives as a Files location may exceed MVP scope.
  - Mitigation: Start with in‑app browsing/preview; re-evaluate File Provider after MVP.
- Performance with large archives: Memory and time constraints in extensions.
  - Mitigation: Streamed IO, chunking, cancellation, and fallback to in‑app flow.
- Encryption variability: ZIP AES-256 vs. legacy; 7z crypto differences.
  - Mitigation: Standardize on strong algorithms; clearly communicate compatibility limits.
- Permissions & bookmarks: Default extraction locations require security-scoped bookmarks.
  - Mitigation: Robust bookmark management; clear error handling and user prompts.
