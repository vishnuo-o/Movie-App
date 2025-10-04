//
//  MovieListView.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import SwiftUI

struct MovieListView: View {

    @EnvironmentObject private var navigationManager: NavigationManager
    
    @StateObject private var viewModel: MovieListViewModel

    init(navigationManager: NavigationManager) {
        _viewModel = StateObject(wrappedValue: MovieListViewModel(navigationManager: navigationManager))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            SearchBar(text: $viewModel.searchQuery)
                .padding()

            // Movie list
            switch viewModel.viewState {
            case .idle:
                Spacer()

            case .loading:
                LoadingView()

            case .loaded(let movies):
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: UIDevice.isPad ? 6 : 3), spacing: 16) {
                        ForEach(movies) { movie in
                            Button {
                                viewModel.navigateToMovieDetail(movieId: movie.id)
                            } label: {
                                MovieCardView(
                                    movie: movie,
                                    isFavorite: viewModel.isFavorite(movie.id),
                                    onFavoriteTap: {
                                        viewModel.toggleFavorite(movie.id)
                                    }
                                )
                                .task {
                                    if movies.last?.id == movie.id {
                                        await viewModel.loadMore()
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .refreshable {
                    await viewModel.retry()
                }

            case .error(let message):
                ErrorView(message: message) {
                    Task {
                        await viewModel.retry()
                    }
                }

            case .empty:
                VStack(spacing: 16) {
                    Image(systemName: "film.stack")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No movies found")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Movies")
        .scrollDismissesKeyboard(.immediately)
        .navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .movieDetail(let movieId):
                MovieDetailView(movieId: movieId)
            }
        }
    }
}
