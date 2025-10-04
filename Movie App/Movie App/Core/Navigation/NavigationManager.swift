//
//  NavigationManager.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import SwiftUI

@MainActor
final class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()

    func navigate(to destination: NavigationDestination) {
        path.append(destination)
    }

    func navigateBack() {
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }
}
