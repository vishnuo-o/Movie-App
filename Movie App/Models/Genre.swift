//
//  Genre.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

struct Genre: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}
