import Foundation
import Testing
@testable import Pressi

struct EngineZipTests {

    @Test func zip_roundtrip_single_file() async throws {
        let service = DefaultArchiveService()
        let fm = FileManager.default
        let tmp = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.createDirectory(at: tmp, withIntermediateDirectories: true)
        let src = tmp.appendingPathComponent("a.txt")
        let contents = Data("hello world".utf8)
        try contents.write(to: src)
        let dest = tmp.appendingPathComponent("out.zip")

        try await service.compress(
            sources: [src],
            destination: dest,
            format: .zip,
            level: .normal,
            password: nil,
            onProgress: { _ in }
        )

        #expect(fm.fileExists(atPath: dest.path))

        let outDir = tmp.appendingPathComponent("unzipped")
        try await service.extract(archive: dest, destination: outDir, password: nil, onProgress: { _ in })
        let outFile = outDir.appendingPathComponent("a.txt")
        let roundtrip = try Data(contentsOf: outFile)
        #expect(roundtrip == contents)
    }

    @Test func zip_roundtrip_multiple_files() async throws {
        let service = DefaultArchiveService()
        let fm = FileManager.default
        let tmp = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.createDirectory(at: tmp, withIntermediateDirectories: true)
        var sources: [URL] = []
        var map: [String: Data] = [:]
        for i in 0..<3 {
            let name = "f_\(i).bin"
            let data = Data((0..<(32 + i)).map { _ in UInt8.random(in: 0...255) })
            let url = tmp.appendingPathComponent(name)
            try data.write(to: url)
            sources.append(url)
            map[name] = data
        }
        let dest = tmp.appendingPathComponent("out.zip")
        try await service.compress(
            sources: sources,
            destination: dest,
            format: .zip,
            level: .normal,
            password: nil,
            onProgress: { _ in }
        )
        let outDir = tmp.appendingPathComponent("unzipped")
        try await service.extract(archive: dest, destination: outDir, password: nil, onProgress: { _ in })
        for (name, data) in map {
            let url = outDir.appendingPathComponent(name)
            let out = try Data(contentsOf: url)
            #expect(out == data)
        }
    }
}

