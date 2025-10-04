//
//  MovieService.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

final class MovieService: MovieServiceProtocol {
    static let shared = MovieService()

    private let networkManager = NetworkManager.shared
    private let maxRetries = 2

    init() {}

    // MARK: API Methods
    
    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        return try await withRetry {
            let urlString = "\(AppConfiguration.baseURL)/movie/popular?api_key=\(AppConfiguration.apiKey)&page=\(page)"
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }

            let response: MoviesResponse = try await self.networkManager.request(url: url)
            return response.results
        }
    }

    func searchMovies(query: String) async throws -> [Movie] {
        return try await withRetry {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            let urlString = "\(AppConfiguration.baseURL)/search/movie?api_key=\(AppConfiguration.apiKey)&query=\(encodedQuery)"
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }

            let response: MoviesResponse = try await self.networkManager.request(url: url)
            return response.results
        }
    }

    func fetchMovieDetails(id: Int) async throws -> MovieDetail {
        return try await withRetry {
            let urlString = "\(AppConfiguration.baseURL)/movie/\(id)?api_key=\(AppConfiguration.apiKey)&append_to_response=credits"
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }

            return try await self.networkManager.request(url: url)
        }
    }

    func fetchMovieVideos(id: Int) async throws -> [Video] {
        return try await withRetry {
            let urlString = "\(AppConfiguration.baseURL)/movie/\(id)/videos?api_key=\(AppConfiguration.apiKey)"
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }

            let response: VideosResponse = try await self.networkManager.request(url: url)
            return response.results
        }
    }

    // MARK: Retry Logic

    private func withRetry<T>(operation: @escaping () async throws -> T) async throws -> T {
        var lastError: Error?

        for attempt in 0...maxRetries {
            do {
                return try await operation()
            } catch {
                lastError = error
                if attempt < maxRetries {
                    try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
                }
            }
        }

        throw lastError ?? NetworkError.unknown(NSError(domain: "MovieService", code: -1))
    }
}
