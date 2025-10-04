//
//  NetworkManager.swift
//  Movie App
//
//  Created by Vishnupriyan Somasundharam on 04/10/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()

    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil
    ) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Log API activity
        logAPIActivity(method: method, url: url)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            logAPIResponse(url: url, statusCode: nil, success: false)
            throw NetworkError.invalidResponse
        }

        let success = (200...299).contains(httpResponse.statusCode)
        logAPIResponse(url: url, statusCode: httpResponse.statusCode, success: success)

        guard success else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}


// MARK: Logging

extension NetworkManager {
    private func logAPIActivity(method: HTTPMethod, url: URL) {
        #if DEBUG
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("🌐 [\(timestamp)] \(method.rawValue) \(url.path)")
        #endif
    }
    
    private func logAPIResponse(url: URL, statusCode: Int?, success: Bool) {
        #if DEBUG
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let icon = success ? "✅" : "❌"
        let status = statusCode.map { "\($0)" } ?? "No Response"
        print("\(icon) [\(timestamp)] \(status) - \(url)")
        #endif
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
