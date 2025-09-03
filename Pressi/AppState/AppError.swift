//
//  AppError.swift
//  Pressi
//
//  Standardized error model for user vs developer errors and cancellation.
//

import Foundation

enum PressiError: Error, Equatable {
    case user(message: String)
    case developer(message: String)
    case cancelled
}

extension PressiError {
    var userMessage: String {
        switch self {
        case .user(let message):
            return message
        case .developer:
            return "Something went wrong. Please try again."
        case .cancelled:
            return "Operation cancelled."
        }
    }
}

struct PresentedError: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
}

