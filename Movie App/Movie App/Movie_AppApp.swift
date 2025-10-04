//
//  Movie_AppApp.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import SwiftUI

@main
struct Movie_AppApp: App {
    
    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationManager.path) {
                MovieListView(navigationManager: navigationManager)
            }
            .environmentObject(navigationManager)
        }
    }
}
