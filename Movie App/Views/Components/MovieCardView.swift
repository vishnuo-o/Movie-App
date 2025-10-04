//
//  MovieCardView.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let isFavorite: Bool
    let onFavoriteTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Poster Image
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: movie.posterURL) { image in
                    GeometryReader { geo in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width)
                    }
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(8)

                // Favorite Button
                Button(action: onFavoriteTap) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .white)
                        .font(.title3)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding(8)
            }

            // Title
            Text(movie.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            // Rating
            RatingView(rating: movie.ratingOutOfFive)

            // Release Date
            Text(movie.formattedReleaseDate)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
