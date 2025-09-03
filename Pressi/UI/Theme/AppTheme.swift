//
//  AppTheme.swift
//  Pressi
//
//  Base theming tokens for colors and typography (PRS-014).
//

import SwiftUI

struct AppTheme {
    struct Palette {
        // System-aware colors to keep excellent Dynamic Type and contrast.
        static let accent = Color.accentColor
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.secondarySystemBackground)
        static let separator = Color(.separator)
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
    }

    struct Typography {
        // Prefer semantic text styles for Dynamic Type support.
        static let largeTitle: Font = .largeTitle
        static let title: Font = .title2
        static let headline: Font = .headline
        static let body: Font = .body
        static let caption: Font = .caption
        static let footnote: Font = .footnote
    }
}

