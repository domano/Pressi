//
//  JobsStore.swift
//  Pressi
//
//  Tracks compression/decompression jobs and progress.
//

import Foundation

struct JobProgress: Identifiable, Equatable {
    enum Kind { case compress, decompress }
    let id = UUID()
    let kind: Kind
    let name: String
    var progress: Double // 0.0 ... 1.0
    var isCancelled: Bool = false
    var isCompleted: Bool = false
}

@MainActor
final class JobsStore: ObservableObject {
    @Published private(set) var jobs: [JobProgress] = []

    func addJob(kind: JobProgress.Kind, name: String) {
        jobs.append(.init(kind: kind, name: name, progress: 0))
    }

    func update(job id: JobProgress.ID, progress: Double) {
        guard let idx = jobs.firstIndex(where: { $0.id == id }) else { return }
        jobs[idx].progress = progress
        if progress >= 1.0 { jobs[idx].isCompleted = true }
    }

    func cancel(job id: JobProgress.ID) {
        guard let idx = jobs.firstIndex(where: { $0.id == id }) else { return }
        jobs[idx].isCancelled = true
    }
}

