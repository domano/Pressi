//
//  RootPlaceholderView.swift
//  Pressi
//
//  M0 scaffolding for initial UI grouping.
//

import SwiftUI

struct RootPlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.stack.3d.up")
                .imageScale(.large)
                .font(.system(size: 40))
            Text("Pressi")
                .font(.title.bold())
            Text("Project setup complete")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    RootPlaceholderView()
}

