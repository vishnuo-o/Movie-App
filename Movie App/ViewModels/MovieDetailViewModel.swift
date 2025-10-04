//
//  MovieDetailViewModel.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

struct MovieDetailData: Equatable {
    let detail: MovieDetail
    let videos: [Video]

    static func == (lhs: MovieDetailData, rhs: MovieDetailData) -> Bool {
        return lhs.detail.id == rhs.detail.id && lhs.videos == rhs.videos
    }
}

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var viewState: ViewState<MovieDetailData> = .idle
    @Published var isFavorite: Bool = false

    private let movieService: MovieServiceProtocol
    private let favoritesManager: FavoritesManager
    private let movieId: Int

    init(
        movieId: Int,
        movieService: MovieServiceProtocol = MovieService.shared,
        favoritesManager: FavoritesManager = FavoritesManager.shared
    ) {
        self.movieId = movieId
        self.movieService = movieService
        self.favoritesManager = favoritesManager
        self.isFavorite = favoritesManager.isFavorite(movieId)
    }

    // MARK: Public Methods

    func loadMovieDetails() async {
        viewState = .loading

        async let detailsTask = movieService.fetchMovieDetails(id: movieId)
        async let videosTask = movieService.fetchMovieVideos(id: movieId)

        do {
            let (details, videos) = try await (detailsTask, videosTask)
            let filteredVideos = videos.filter { $0.isTrailer && $0.site.lowercased() == "youtube" }
            let data = MovieDetailData(detail: details, videos: filteredVideos)
            viewState = .loaded(data)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    func toggleFavorite() {
        favoritesManager.toggleFavorite(movieId)
        isFavorite = favoritesManager.isFavorite(movieId)
    }

    func retry() async {
        await loadMovieDetails()
    }

    var trailer: Video? {
        if case .loaded(let data) = viewState {
            return data.videos.first
        }
        return nil
    }
    
    deinit {
        print("MovieDetailViewModel - deinitialized")
    }
}
