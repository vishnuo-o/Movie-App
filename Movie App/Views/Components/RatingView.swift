//
//  RatingView.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import SwiftUI

struct RatingView: View {
    let rating: Double
    let maxRating: Int = 5

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxRating, id: \.self) { index in
                Image(systemName: starType(for: index))
                    .foregroundColor(.yellow)
                    .font(.caption)
            }

            Text(String(format: "%.1f", rating))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private func starType(for index: Int) -> String {
        let fillLevel = rating - Double(index)

        if fillLevel >= 1.0 {
            return "star.fill"
        } else if fillLevel >= 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}
