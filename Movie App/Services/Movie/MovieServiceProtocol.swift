//
//  MovieServiceProtocol.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchPopularMovies(page: Int) async throws -> [Movie]
    func searchMovies(query: String) async throws -> [Movie]
    func fetchMovieDetails(id: Int) async throws -> MovieDetail
    func fetchMovieVideos(id: Int) async throws -> [Video]
}
