//
//  FavoritesServiceProtocol.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

protocol FavoritesServiceProtocol {
    func getFavorites() -> Set<Int>
    func isFavorite(_ movieId: Int) -> Bool
    func toggleFavorite(_ movieId: Int)
    func addFavorite(_ movieId: Int)
    func removeFavorite(_ movieId: Int)
}
