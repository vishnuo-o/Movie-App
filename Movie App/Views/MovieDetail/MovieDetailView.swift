//
//  MovieDetailView.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(movieId: Int) {
        self.movieId = movieId
        self._viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId))
    }
    
    private let videoPlayerHeight =  UIScreen.height * 0.3
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .idle:
                EmptyView()
                
            case .loading:
                LoadingView()
                
            case .loaded(let data):
                movieDetailContent(movie: data.detail, trailer: data.videos.first)
                
            case .error(let message):
                ErrorView(message: message) {
                    Task {
                        await viewModel.retry()
                    }
                }
                
            case .empty:
                EmptyView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadMovieDetails()
        }
    }
    
    @ViewBuilder
    private func movieDetailContent(movie: MovieDetail, trailer: Video?) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                // Trailer Player
                if let youtubeURL = trailer?.youtubeURL {
                    VideoPlayerView(url: youtubeURL)
                        .frame(height: videoPlayerHeight)
                } else if let backdropURL = movie.backdropURL {
                    AsyncImage(url: backdropURL) { image in
                        GeometryReader { geo in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width)
                        }
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: videoPlayerHeight)
                    .clipped()
                } else {
                    EmptyView()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    // Title and Favorite
                    HStack(alignment: .firstTextBaseline) {
                        Text(movie.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: { viewModel.toggleFavorite() }) {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(viewModel.isFavorite ? .red : .gray)
                                .font(.title)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Rating
                    RatingView(rating: movie.ratingOutOfFive)
                        .padding(.horizontal)
                    
                    // Genre
                    if !movie.genres.isEmpty {
                    Text(movie.genreNames)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    }
                    
                    // Duration, Release Date
                    HStack(spacing: 8) {
                        Text(movie.formattedRuntime)
                        Text("|")
                        Text(movie.formattedReleaseDate)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    
                    // Overview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Plot")
                            .font(.headline)
                        
                        Text(movie.overview)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding([.top, .horizontal])
                    
                    // Cast
                    if !movie.cast.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Cast")
                                .font(.headline)
                                .padding([.top, .horizontal])
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(movie.cast.prefix(10)) { castMember in
                                        CastCardView(cast: castMember)
                                    }
                                }
                            }
                            .safeAreaInset(edge: .leading) {
                                Color.clear.frame(width: 8)
                            }
                            .safeAreaInset(edge: .trailing) {
                                Color.clear.frame(width: 8)
                            }
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 60)
        }
    }
}

// MARK: Cast Card View

struct CastCardView: View {
    let cast: Cast
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: cast.profileURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    }
            }
            .frame(width: 80, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(spacing: 4) {
                Text(cast.name)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(cast.character)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .lineLimit(2)
            .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: 80, maxHeight: .infinity, alignment: .top)
    }
}
