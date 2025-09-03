//
//  RootView.swift
//  Pressi
//
//  Root navigation: Home and Settings.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var jobs: JobsStore

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .overlay(alignment: .bottom) {
            if !jobs.jobs.isEmpty {
                JobsStrip(jobs: jobs.jobs)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.default, value: jobs.jobs)
    }
}

private struct JobsStrip: View {
    let jobs: [JobProgress]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(jobs) { job in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(job.name).font(.caption).lineLimit(1)
                        ProgressView(value: job.progress)
                            .progressViewStyle(.linear)
                    }
                    .padding(8)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(.thinMaterial)
    }
}

struct HomeView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var jobs: JobsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Quick Actions") {
                    Button {
                        jobs.addJob(kind: .compress, name: "Sample Compress")
                    } label: {
                        Label("Compress Files", systemImage: "arrow.down.circle")
                    }
                    Button {
                        jobs.addJob(kind: .decompress, name: "Sample Decompress")
                    } label: {
                        Label("Decompress Archive", systemImage: "arrow.up.circle")
                    }
                }

                Section("Defaults") {
                    HStack {
                        Label("Format", systemImage: "doc.zipper")
                        Spacer()
                        Text(settings.defaultFormat.uppercased())
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Label("Level", systemImage: "gauge.with.dots.needle.bottom.50percent")
                        Spacer()
                        Text(settings.compressionLevel.rawValue.capitalized)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Pressi")
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsStore

    var body: some View {
        NavigationStack {
            Form {
                Picker("Default Format", selection: $settings.defaultFormat) {
                    Text("ZIP").tag("zip")
                    Text("7Z").tag("7z")
                    Text("TAR").tag("tar")
                    Text("GZ").tag("gz")
                }

                Picker("Compression Level", selection: $settings.compressionLevel) {
                    ForEach(SettingsStore.CompressionLevel.allCases) { level in
                        Text(level.rawValue.capitalized).tag(level)
                    }
                }

                Toggle("Encrypt by Default", isOn: $settings.encryptByDefault)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    RootView()
        .environmentObject(SettingsStore())
        .environmentObject(JobsStore())
}

