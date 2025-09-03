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
        .tint(AppTheme.Palette.accent)
        .overlay(alignment: .bottom) {
            if !jobs.jobs.isEmpty {
                JobsStrip(jobs: jobs.jobs)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.default, value: jobs.jobs)
        .alert(item: $jobs.presentedError) { err in
            Alert(title: Text(err.title), message: Text(err.message), dismissButton: .default(Text("OK")))
        }
    }
}

private struct JobsStrip: View {
    let jobs: [JobProgress]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(jobs) { job in
                    HStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(job.name)
                                .font(AppTheme.Typography.caption)
                                .foregroundStyle(AppTheme.Palette.textSecondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            ProgressView(value: job.progress)
                                .progressViewStyle(.linear)
                        }
                        if !job.isCompleted && !job.isCancelled {
                            CancelButton(jobID: job.id)
                        }
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
                        _ = jobs.start(kind: .compress, name: "Sample Compress")
                    } label: {
                        Label("Compress Files", systemImage: "arrow.down.circle")
                    }
                    Button {
                        _ = jobs.start(kind: .decompress, name: "Sample Decompress")
                    } label: {
                        Label("Decompress Archive", systemImage: "arrow.up.circle")
                    }
                    Button {
                        _ = jobs.start(kind: .compress, name: "Sample Fail")
                    } label: {
                        Label("Start Failing Job", systemImage: "exclamationmark.triangle")
                    }
                }

                Section("Defaults") {
                    HStack {
                        Label("Format", systemImage: "doc.zipper")
                        Spacer()
                        Text(settings.defaultFormat.uppercased())
                            .foregroundStyle(AppTheme.Palette.textSecondary)
                    }
                    HStack {
                        Label("Level", systemImage: "gauge.with.dots.needle.bottom.50percent")
                        Spacer()
                        Text(settings.compressionLevel.rawValue.capitalized)
                            .foregroundStyle(AppTheme.Palette.textSecondary)
                    }
                }
            }
            .navigationTitle("Pressi")
        }
    }
}

private struct CancelButton: View {
    @EnvironmentObject private var jobsStore: JobsStore
    let jobID: JobProgress.ID
    var body: some View {
        Button {
            jobsStore.cancel(job: jobID)
        } label: {
            Image(systemName: "xmark.circle.fill")
        }
        .buttonStyle(.borderless)
        .foregroundStyle(AppTheme.Palette.textSecondary)
        .accessibilityLabel("Cancel job")
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
