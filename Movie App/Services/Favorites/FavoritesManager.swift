//
//  FavoritesManager.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation
import Combine

final class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    // Publisher to notify when favorites change
    let favoritesDidChange = PassthroughSubject<Void, Never>()

    private let service: FavoritesServiceProtocol

    init(service: FavoritesServiceProtocol = FavoritesService.shared) {
        self.service = service
    }

    // MARK:  Public Methods

    func getFavorites() -> Set<Int> {
        return service.getFavorites()
    }

    func isFavorite(_ movieId: Int) -> Bool {
        return service.isFavorite(movieId)
    }

    func toggleFavorite(_ movieId: Int) {
        service.toggleFavorite(movieId)
        favoritesDidChange.send()
    }

    func addFavorite(_ movieId: Int) {
        service.addFavorite(movieId)
        favoritesDidChange.send()
    }

    func removeFavorite(_ movieId: Int) {
        service.removeFavorite(movieId)
        favoritesDidChange.send()
    }
}
