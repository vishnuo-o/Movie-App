//
//  MovieListViewModel.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation
import Combine

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published var viewState: ViewState<[Movie]> = .idle
    @Published var searchQuery: String = ""
    @Published var favorites: Set<Int> = []

    private let movieService: MovieServiceProtocol
    private let favoritesManager: FavoritesManager
    private let navigationManager: NavigationManager
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    // Pagination
    private var currentPage: Int = 1
    private var isLoadingMore: Bool = false
    private var canLoadMore: Bool = true

    // Computed property for easy access to movies
    var movies: [Movie] {
        if case .loaded(let movies) = viewState {
            return movies
        }
        return []
    }

    init(
        movieService: MovieServiceProtocol = MovieService.shared,
        favoritesManager: FavoritesManager = FavoritesManager.shared,
        navigationManager: NavigationManager
    ) {
        self.movieService = movieService
        self.favoritesManager = favoritesManager
        self.navigationManager = navigationManager
        loadFavorites()
        setupSearchDebounce()
        observeFavoritesChanges()
    }

    // MARK: Public Methods

    func loadPopularMovies() async {
        currentPage = 1
        canLoadMore = true
        await loadPopularMovies(page: 1)
    }

    private func loadPopularMovies(page: Int) async {
        // Prevent duplicate loads
        guard !isLoadingMore else { return }

        if page == 1 {
            viewState = .loading
        } else {
            isLoadingMore = true
        }

        do {
            let newMovies = try await movieService.fetchPopularMovies(page: page)

            if page == 1 {
                if newMovies.isEmpty {
                    viewState = .empty
                } else {
                    viewState = .loaded(newMovies)
                }
            } else {
                // Append to existing movies for pagination
                let currentMovies = movies
                viewState = .loaded(currentMovies + newMovies)
            }

            // If we got fewer movies than expected, we've reached the end
            canLoadMore = !newMovies.isEmpty
        } catch {
            if page == 1 {
                viewState = .error(error.localizedDescription)
            }
            canLoadMore = false
        }

        isLoadingMore = false
    }

    func loadMore() async {
        guard canLoadMore && !isLoadingMore && !viewState.isLoading else { return }
        currentPage += 1
        await loadPopularMovies(page: currentPage)
    }

    func searchMovies() async {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            currentPage = 1
            canLoadMore = true
            await loadPopularMovies(page: 1)
            return
        }

        viewState = .loading
        canLoadMore = false // Disabled pagination for search

        do {
            currentPage = 1
            let searchResults = try await movieService.searchMovies(query: searchQuery)
            if searchResults.isEmpty {
                viewState = .empty
            } else {
                viewState = .loaded(searchResults)
            }
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    func toggleFavorite(_ movieId: Int) {
        favoritesManager.toggleFavorite(movieId)
    }

    func isFavorite(_ movieId: Int) -> Bool {
        favorites.contains(movieId)
    }

    func retry() async {
        if searchQuery.isEmpty {
            currentPage = 1
            canLoadMore = true
            await loadPopularMovies(page: 1)
        } else {
            await searchMovies()
        }
    }

    func navigateToMovieDetail(movieId: Int) {
        navigationManager.navigate(to: .movieDetail(movieId: movieId))
    }

    // MARK: Private Methods

    private func loadFavorites() {
        favorites = favoritesManager.getFavorites()
    }

    private func observeFavoritesChanges() {
        favoritesManager.favoritesDidChange
            .sink { [weak self] in
                self?.loadFavorites()
            }
            .store(in: &cancellables)
    }

    private func setupSearchDebounce() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.searchTask?.cancel()
                self?.searchTask = Task {
                    await self?.searchMovies()
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        print("MovieListViewModel - deinitialized")
    }
}
