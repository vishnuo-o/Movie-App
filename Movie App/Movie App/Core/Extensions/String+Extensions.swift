//
//  String+Extensions.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

extension String {
    /// Converts date string to formatted display string
    func toFormattedDate(format: String = "MMM d, yyyy") -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: self) else { return self }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = format
        return outputFormatter.string(from: date)
    }

    /// Builds full image URL from TMDB path
    func toImageURL(size: String = AppConfiguration.posterSize) -> URL? {
        guard !isEmpty else { return nil }
        let urlString = "\(AppConfiguration.imageBaseURL)\(size)\(self)"
        return URL(string: urlString)
    }

    /// Converts runtime in minutes to hours and minutes format
    static func formatRuntime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        if hours > 0 {
            return "\(hours)h \(mins)m"
        }
        return "\(mins)m"
    }
}
