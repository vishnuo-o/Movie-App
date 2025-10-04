//
//  ViewState.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(String)
    case empty

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var isEmpty: Bool {
        if case .empty = self {
            return true
        }
        return false
    }

    var error: String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }
}

// Equatable conformance for ViewState
extension ViewState: Equatable where T: Equatable {
    static func == (lhs: ViewState<T>, rhs: ViewState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.empty, .empty):
            return true
        case (.error(let lhsMsg), .error(let rhsMsg)):
            return lhsMsg == rhsMsg
        case (.loaded(let lhsData), .loaded(let rhsData)):
            return lhsData == rhsData
        default:
            return false
        }
    }
}
