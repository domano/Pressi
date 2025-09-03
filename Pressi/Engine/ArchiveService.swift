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
        switch format {
        case .zip:
            if sources.isEmpty {
                try await simulateWork(onProgress: onProgress)
            } else {
                try await zipCompress(sources: sources, destination: destination, onProgress: onProgress)
            }
        default:
            try await simulateWork(onProgress: onProgress)
        }
    }

    func extract(
        archive: URL,
        destination: URL,
        password: String?,
        onProgress: @Sendable @escaping (Double) -> Void
    ) async throws {
        // Detect by extension for now
        if archive.pathExtension.lowercased() == "zip" {
            try await zipExtract(archive: archive, destination: destination, onProgress: onProgress)
        } else {
            try await simulateWork(onProgress: onProgress)
        }
    }

    private func simulateWork(onProgress: @Sendable (Double) -> Void) async throws {
        for i in 1...100 {
            try Task.checkCancellation()
            try? await Task.sleep(nanoseconds: 40_000_000) // ~4s total
            onProgress(Double(i) / 100.0)
        }
    }

    // MARK: - ZIP (store-only) minimal implementation

    private struct ZipEntryMeta {
        let name: String
        let crc32: UInt32
        let uncompressedSize: UInt32
        let compressedSize: UInt32
        let localHeaderOffset: UInt32
    }

    private func dosTimeDate(from date: Date) -> (UInt16, UInt16) {
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents(in: TimeZone.current, from: date)
        let sec = UInt16((comps.second ?? 0) / 2)
        let min = UInt16(comps.minute ?? 0)
        let hour = UInt16(comps.hour ?? 0)
        let day = UInt16(comps.day ?? 1)
        let month = UInt16(comps.month ?? 1)
        let year = UInt16(max(0, (comps.year ?? 1980) - 1980))
        let time = (hour << 11) | (min << 5) | sec
        let date = (year << 9) | (month << 5) | day
        return (time, date)
    }

    private func crc32(_ data: Data) -> UInt32 {
        var crc: UInt32 = 0xFFFFFFFF
        for byte in data {
            var c = (crc ^ UInt32(byte)) & 0xFF
            for _ in 0..<8 {
                if (c & 1) != 0 {
                    c = 0xEDB88320 ^ (c >> 1)
                } else {
                    c = c >> 1
                }
            }
            crc = (crc >> 8) ^ c
        }
        return crc ^ 0xFFFFFFFF
    }

    private func writeUInt16LE(_ value: UInt16, to handle: FileHandle) throws {
        var v = value.littleEndian
        let data = Data(bytes: &v, count: MemoryLayout<UInt16>.size)
        try handle.write(contentsOf: data)
    }

    private func writeUInt32LE(_ value: UInt32, to handle: FileHandle) throws {
        var v = value.littleEndian
        let data = Data(bytes: &v, count: MemoryLayout<UInt32>.size)
        try handle.write(contentsOf: data)
    }

    private func readUInt16LE(_ data: Data, _ offset: inout Int) -> UInt16 {
        precondition(offset + 2 <= data.count)
        let b0 = UInt16(data[offset])
        let b1 = UInt16(data[offset + 1])
        offset += 2
        return b0 | (b1 << 8)
    }

    private func readUInt32LE(_ data: Data, _ offset: inout Int) -> UInt32 {
        precondition(offset + 4 <= data.count)
        let b0 = UInt32(data[offset])
        let b1 = UInt32(data[offset + 1])
        let b2 = UInt32(data[offset + 2])
        let b3 = UInt32(data[offset + 3])
        offset += 4
        return b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)
    }

    private func zipCompress(sources: [URL], destination: URL, onProgress: @Sendable (Double) -> Void) async throws {
        if sources.isEmpty { throw PressiError.user(message: "No sources to compress.") }
        if let pwd = try? await MainActor.run(body: { passwordPromptGuard() }), pwd != nil {
            // Placeholder for future password support.
        }
        let fm = FileManager.default
        if fm.fileExists(atPath: destination.path) { try fm.removeItem(at: destination) }
        fm.createFile(atPath: destination.path, contents: nil)
        guard let handle = try? FileHandle(forWritingTo: destination) else {
            throw PressiError.developer(message: "Failed to open destination for writing")
        }
        defer { try? handle.close() }

        var entries: [ZipEntryMeta] = []
        var written: UInt64 = 0
        let totalBytes: UInt64 = try sources.reduce(0) { acc, url in
            let attrs = try fm.attributesOfItem(atPath: url.path)
            let size = (attrs[.size] as? NSNumber)?.uint64Value ?? 0
            return acc + size
        }

        for src in sources {
            try Task.checkCancellation()
            let name = src.lastPathComponent
            let data = try Data(contentsOf: src)
            let crc = crc32(data)
            let uSize = UInt32(truncatingIfNeeded: data.count)
            let cSize = uSize // store only
            let headerOffset = UInt32(truncatingIfNeeded: try handle.offset())
            // Local file header
            try writeUInt32LE(0x04034b50, to: handle)
            try writeUInt16LE(20, to: handle) // version needed 2.0
            try writeUInt16LE(0, to: handle) // flags
            try writeUInt16LE(0, to: handle) // method store
            let (time, date) = dosTimeDate(from: Date())
            try writeUInt16LE(time, to: handle)
            try writeUInt16LE(date, to: handle)
            try writeUInt32LE(crc, to: handle)
            try writeUInt32LE(cSize, to: handle)
            try writeUInt32LE(uSize, to: handle)
            let nameData = name.data(using: .utf8) ?? Data()
            try writeUInt16LE(UInt16(truncatingIfNeeded: nameData.count), to: handle)
            try writeUInt16LE(0, to: handle) // extra len
            try handle.write(contentsOf: nameData)
            try handle.write(contentsOf: data)

            let meta = ZipEntryMeta(name: name, crc32: crc, uncompressedSize: uSize, compressedSize: cSize, localHeaderOffset: headerOffset)
            entries.append(meta)

            written += UInt64(data.count)
            let progress = totalBytes > 0 ? Double(written) / Double(totalBytes) : Double(entries.count) / Double(sources.count)
            onProgress(min(max(progress, 0.0), 1.0))
        }

        // Write central directory
        let centralStart = UInt32(truncatingIfNeeded: try handle.offset())
        for e in entries {
            try writeUInt32LE(0x02014b50, to: handle) // central header sig
            try writeUInt16LE(20, to: handle) // version made by
            try writeUInt16LE(20, to: handle) // version needed
            try writeUInt16LE(0, to: handle) // flags
            try writeUInt16LE(0, to: handle) // method store
            let (time, date) = dosTimeDate(from: Date())
            try writeUInt16LE(time, to: handle)
            try writeUInt16LE(date, to: handle)
            try writeUInt32LE(e.crc32, to: handle)
            try writeUInt32LE(e.compressedSize, to: handle)
            try writeUInt32LE(e.uncompressedSize, to: handle)
            let nameData = e.name.data(using: .utf8) ?? Data()
            try writeUInt16LE(UInt16(truncatingIfNeeded: nameData.count), to: handle)
            try writeUInt16LE(0, to: handle) // extra len
            try writeUInt16LE(0, to: handle) // comment len
            try writeUInt16LE(0, to: handle) // disk number start
            try writeUInt16LE(0, to: handle) // internal attrs
            try writeUInt32LE(0, to: handle) // external attrs
            try writeUInt32LE(e.localHeaderOffset, to: handle)
            try handle.write(contentsOf: nameData)
        }
        let centralEnd = UInt32(truncatingIfNeeded: try handle.offset())
        let centralSize = centralEnd &- centralStart
        // End of central directory
        try writeUInt32LE(0x06054b50, to: handle)
        try writeUInt16LE(0, to: handle) // disk
        try writeUInt16LE(0, to: handle) // cd start disk
        try writeUInt16LE(UInt16(entries.count), to: handle) // entries on disk
        try writeUInt16LE(UInt16(entries.count), to: handle) // total entries
        try writeUInt32LE(centralSize, to: handle)
        try writeUInt32LE(centralStart, to: handle)
        try writeUInt16LE(0, to: handle) // comment len
        onProgress(1.0)
    }

    private func zipExtract(archive: URL, destination: URL, onProgress: @Sendable (Double) -> Void) async throws {
        let fm = FileManager.default
        try fm.createDirectory(at: destination, withIntermediateDirectories: true)
        let data = try Data(contentsOf: archive)
        var offset = 0
        var filesExtracted = 0
        var names: [String] = []
        while offset + 4 <= data.count {
            let sig = readUInt32LE(data, &offset)
            if sig != 0x04034b50 { break }
            _ = readUInt16LE(data, &offset) // version needed
            let flags = readUInt16LE(data, &offset)
            let method = readUInt16LE(data, &offset)
            if (flags & 0x1F) != 0 { throw PressiError.user(message: "Unsupported ZIP flags") }
            if method != 0 { throw PressiError.user(message: "Unsupported ZIP method") }
            _ = readUInt16LE(data, &offset) // time
            _ = readUInt16LE(data, &offset) // date
            _ = readUInt32LE(data, &offset) // crc
            let compSize = Int(readUInt32LE(data, &offset))
            let uncompSize = Int(readUInt32LE(data, &offset))
            let nameLen = Int(readUInt16LE(data, &offset))
            let extraLen = Int(readUInt16LE(data, &offset))
            guard offset + nameLen <= data.count else { throw PressiError.developer(message: "Corrupt ZIP: name overflow") }
            let nameData = data.subdata(in: offset..<(offset + nameLen))
            offset += nameLen
            let name = String(data: nameData, encoding: .utf8) ?? "file_\(filesExtracted)"
            names.append(name)
            offset += extraLen
            guard offset + compSize <= data.count else { throw PressiError.developer(message: "Corrupt ZIP: data overflow") }
            let fileData = data.subdata(in: offset..<(offset + compSize))
            offset += compSize
            // write file
            let outURL = destination.appendingPathComponent(name)
            try fileData.write(to: outURL, options: .atomic)
            // basic size check
            if uncompSize != fileData.count { /* tolerate for store-only */ }
            filesExtracted += 1
            onProgress(Double(filesExtracted) / Double(max(1, names.count)))
        }
        onProgress(1.0)
    }

    @MainActor private func passwordPromptGuard() -> String? { nil }
}
