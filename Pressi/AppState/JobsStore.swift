//
//  JobsStore.swift
//  Pressi
//
//  Tracks compression/decompression jobs and progress.
//

import Foundation

protocol JobRunner {
    func run(kind: JobProgress.Kind, name: String, onProgress: @Sendable @escaping (Double) -> Void) async
}

/// Default simulated runner until Engine is implemented.
struct SimulatedRunner: JobRunner {
    init() {}
    func run(kind: JobProgress.Kind, name: String, onProgress: @Sendable @escaping (Double) -> Void) async {
        // Simulate work by stepping progress on a background task.
        for i in 1...100 {
            if Task.isCancelled { break }
            try? await Task.sleep(nanoseconds: 40_000_000) // 40ms ~4s total
            onProgress(Double(i) / 100.0)
        }
    }
}

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
    private var tasks: [JobProgress.ID: Task<Void, Never>] = [:]
    private let runner: JobRunner

    init(runner: JobRunner = SimulatedRunner()) {
        self.runner = runner
    }

    func start(kind: JobProgress.Kind, name: String) -> JobProgress.ID {
        let job = JobProgress(kind: kind, name: name, progress: 0)
        jobs.append(job)

        let jobID = job.id
        let runner = self.runner
        let task = Task.detached(priority: .userInitiated) { [weak self] in
            await runner.run(kind: kind, name: name) { progress in
                Task { @MainActor [weak self] in
                    self?.update(job: jobID, progress: progress)
                }
            }
        }
        tasks[jobID] = task
        return jobID
    }

    func update(job id: JobProgress.ID, progress: Double) {
        guard let idx = jobs.firstIndex(where: { $0.id == id }) else { return }
        jobs[idx].progress = progress
        if progress >= 1.0 {
            jobs[idx].isCompleted = true
            tasks[id]?.cancel()
            tasks[id] = nil
        }
    }

    func cancel(job id: JobProgress.ID) {
        guard let idx = jobs.firstIndex(where: { $0.id == id }) else { return }
        jobs[idx].isCancelled = true
        tasks[id]?.cancel()
        tasks[id] = nil
    }
}
