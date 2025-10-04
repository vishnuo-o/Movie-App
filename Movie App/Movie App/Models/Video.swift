//
//  Video.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

struct Video: Codable, Identifiable, Hashable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let official: Bool
    let publishedAt: String

    enum CodingKeys: String, CodingKey {
        case id, key, name, site, type, official
        case publishedAt = "published_at"
    }

    var youtubeURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }

    var isTrailer: Bool {
        type.lowercased() == "trailer"
    }
}
