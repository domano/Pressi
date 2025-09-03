//
//  JobsStore.swift
//  Pressi
//
//  Tracks compression/decompression jobs and progress.
//

import Foundation

protocol JobRunner {
    func run(kind: JobProgress.Kind, name: String, onProgress: @Sendable @escaping (Double) -> Void) async throws
}

/// Default simulated runner until Engine is implemented.
struct SimulatedRunner: JobRunner {
    init() {}
    func run(kind: JobProgress.Kind, name: String, onProgress: @Sendable @escaping (Double) -> Void) async throws {
        // Simulate work by stepping progress on a background task.
        for i in 1...100 {
            if Task.isCancelled { break }
            try? await Task.sleep(nanoseconds: 40_000_000) // 40ms ~4s total
            onProgress(Double(i) / 100.0)
            // Simulate an error for demonstration if name suggests failure
            if i == 30 && name.lowercased().contains("fail") {
                throw PressiError.user(message: "Failed to process the item.")
            }
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
    @Published var presentedError: PresentedError?

    init(runner: JobRunner = EngineRunner(service: DefaultArchiveService(), defaultFormat: .zip, defaultLevel: .normal)) {
        self.runner = runner
    }

    func start(kind: JobProgress.Kind, name: String) -> JobProgress.ID {
        let job = JobProgress(kind: kind, name: name, progress: 0)
        jobs.append(job)

        let jobID = job.id
        let runner = self.runner
        let task = Task.detached(priority: .userInitiated) { [weak self] in
            do {
                try await runner.run(kind: kind, name: name) { progress in
                    Task { @MainActor [weak self] in
                        self?.update(job: jobID, progress: progress)
                    }
                }
            } catch is CancellationError {
                await MainActor.run { [weak self] in
                    self?.markCancelled(job: jobID)
                }
            } catch let error as PressiError {
                await MainActor.run { [weak self] in
                    self?.handleFailure(job: jobID, error: error)
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.handleFailure(job: jobID, error: .developer(message: error.localizedDescription))
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

    private func markCancelled(job id: JobProgress.ID) {
        guard let idx = jobs.firstIndex(where: { $0.id == id }) else { return }
        jobs[idx].isCancelled = true
        tasks[id]?.cancel()
        tasks[id] = nil
    }

    private func handleFailure(job id: JobProgress.ID, error: PressiError) {
        guard let idx = jobs.firstIndex(where: { $0.id == id }) else { return }
        // Mark job as completed to hide progress strip card
        jobs[idx].isCompleted = true
        tasks[id]?.cancel()
        tasks[id] = nil
        // Present user-friendly alert
        presentedError = PresentedError(title: "Operation Failed", message: error.userMessage)
    }
}
