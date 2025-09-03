//
//  EngineRunner.swift
//  Pressi
//
//  Adapts ArchiveService to JobsStore's JobRunner.
//

import Foundation

struct EngineRunner: JobRunner {
    let service: ArchiveService
    let defaultFormat: ArchiveFormat
    let defaultLevel: EngineCompressionLevel

    init(service: ArchiveService, defaultFormat: ArchiveFormat, defaultLevel: EngineCompressionLevel) {
        self.service = service
        self.defaultFormat = defaultFormat
        self.defaultLevel = defaultLevel
    }

    func run(kind: JobProgress.Kind, name: String, onProgress: @Sendable @escaping (Double) -> Void) async throws {
        // Preserve demo failure behavior to keep PRS-013 UI visible when name contains "fail".
        if name.lowercased().contains("fail") {
            try await simulateFailingProgress(onProgress: onProgress)
            return
        }

        // Temporary URLs for stubbed service; real integration will pass actual file paths.
        let tmpDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let dest = tmpDir.appendingPathComponent(UUID().uuidString)
        switch kind {
        case .compress:
            try await service.compress(
                sources: [],
                destination: dest,
                format: defaultFormat,
                level: defaultLevel,
                password: nil,
                onProgress: onProgress
            )
        case .decompress:
            try await service.extract(
                archive: dest, // placeholder; stub ignores
                destination: tmpDir,
                password: nil,
                onProgress: onProgress
            )
        }
    }

    private func simulateFailingProgress(onProgress: @Sendable (Double) -> Void) async throws {
        for i in 1...100 {
            try Task.checkCancellation()
            try? await Task.sleep(nanoseconds: 40_000_000)
            onProgress(Double(i) / 100.0)
            if i == 30 { throw PressiError.user(message: "Failed to process the item.") }
        }
    }
}
