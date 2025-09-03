//
//  ArchiveService.swift
//  Pressi
//
//  PRS-021: Engine abstraction with async progress and cancellation.
//

import Foundation

enum ArchiveFormat: String, CaseIterable {
    case zip
    case sevenZ
    case tar
    case tarGz
    case tarBz2
    case tarXz
    case gz
}

enum EngineCompressionLevel: String, CaseIterable { case fast, normal, maximum }

protocol ArchiveService {

    func compress(
        sources: [URL],
        destination: URL,
        format: ArchiveFormat,
        level: EngineCompressionLevel,
        password: String?,
        onProgress: @Sendable @escaping (Double) -> Void
    ) async throws

    func extract(
        archive: URL,
        destination: URL,
        password: String?,
        onProgress: @Sendable @escaping (Double) -> Void
    ) async throws
}

/// Default stub implementation that simulates progress.
struct DefaultArchiveService: ArchiveService {
    init() {}

    func compress(
        sources: [URL],
        destination: URL,
        format: ArchiveFormat,
        level: EngineCompressionLevel,
        password: String?,
        onProgress: @Sendable @escaping (Double) -> Void
    ) async throws {
        try await simulateWork(onProgress: onProgress)
    }

    func extract(
        archive: URL,
        destination: URL,
        password: String?,
        onProgress: @Sendable @escaping (Double) -> Void
    ) async throws {
        try await simulateWork(onProgress: onProgress)
    }

    private func simulateWork(onProgress: @Sendable (Double) -> Void) async throws {
        for i in 1...100 {
            try Task.checkCancellation()
            try? await Task.sleep(nanoseconds: 40_000_000) // ~4s total
            onProgress(Double(i) / 100.0)
        }
    }
}
