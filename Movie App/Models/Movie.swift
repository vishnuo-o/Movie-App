//
//  Movie.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

struct Movie: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    // Computed properties for display
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
