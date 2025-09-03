//
//  SettingsStore.swift
//  Pressi
//
//  App-wide user settings and defaults.
//

import Foundation
import SwiftUI

@MainActor
final class SettingsStore: ObservableObject {
    enum CompressionLevel: String, CaseIterable, Identifiable {
        case fast, normal, maximum
        var id: String { rawValue }
    }

    @Published var defaultFormat: String = "zip"
    @Published var compressionLevel: CompressionLevel = .normal
    @Published var encryptByDefault: Bool = false
}

