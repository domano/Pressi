//
//  PressiApp.swift
//  Pressi
//
//  Created by Dino Omanovic on 2025-09-03.
//

import SwiftUI
import SwiftData

@main
struct PressiApp: App {
    @StateObject private var settings = SettingsStore()
    @StateObject private var jobs = JobsStore()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settings)
                .environmentObject(jobs)
        }
        .modelContainer(sharedModelContainer)
    }
}
