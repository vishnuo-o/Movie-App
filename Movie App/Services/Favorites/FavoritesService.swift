//
//  FavoritesService.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation
import CoreData

final class FavoritesService: FavoritesServiceProtocol {
    static let shared = FavoritesService()

    private let coreDataManager = CoreDataManager.shared
    private var context: NSManagedObjectContext {
        coreDataManager.viewContext
    }

    init() {}

    // MARK:  Public Methods

    func getFavorites() -> Set<Int> {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()

        do {
            let favorites = try context.fetch(fetchRequest)
            return Set(favorites.map { Int($0.id) })
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }

    func isFavorite(_ movieId: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
        fetchRequest.fetchLimit = 1

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorite: \(error)")
            return false
        }
    }

    func toggleFavorite(_ movieId: Int) {
        if isFavorite(movieId) {
            removeFavorite(movieId)
        } else {
            addFavorite(movieId)
        }
    }

    func addFavorite(_ movieId: Int) {
        // Check if already exists
        guard !isFavorite(movieId) else { return }

        let favorite = FavoriteMovie(context: context)
        favorite.id = Int32(movieId)
        favorite.addedDate = Date()

        saveContext()
    }

    func removeFavorite(_ movieId: Int) {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)

        do {
            let favorites = try context.fetch(fetchRequest)
            favorites.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }

    // MARK:  Private Methods

    private func saveContext() {
        coreDataManager.saveContext()
    }
}
