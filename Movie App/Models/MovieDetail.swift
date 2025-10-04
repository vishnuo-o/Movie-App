//
//  MovieDetail.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

struct MovieDetail: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let genres: [Genre]
    let credits: Credits?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, credits
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    // Convert to Movie type for compatibility
    var asMovie: Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }

    var cast: [Cast] {
        credits?.cast ?? []
    }

    var genreNames: String {
        genres.map { $0.name }.joined(separator: ", ")
    }

    var formattedRuntime: String {
        guard let runtime = runtime else { return "N/A" }
        return String.formatRuntime(runtime)
    }

    var posterURL: URL? {
        posterPath?.toImageURL()
    }

    var backdropURL: URL? {
        backdropPath?.toImageURL(size: AppConfiguration.backdropSize)
    }

    var formattedReleaseDate: String {
        releaseDate?.toFormattedDate() ?? "N/A"
    }

    var ratingOutOfFive: Double {
        voteAverage / 2.0
    }
}

struct Credits: Codable {
    let cast: [Cast]
}
