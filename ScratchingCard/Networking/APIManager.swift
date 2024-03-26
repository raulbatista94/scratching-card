//
//  APIManager.swift
//  ScratchingCard
//
//  Created by Raul Batista on 25.03.2024.
//

import Foundation

// MARK: - Protocol
protocol APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// MARK: - Implementation
final class APIManager: APIManaging {
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30

        return URLSession(configuration: config)
    }()

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    private func request(_ endpoint: Endpoint) async throws -> Data {
        let request: URLRequest = try endpoint.asRequest()

        print("🚀 Request for \"\(request.description)\"")

        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.unacceptableResponseStatusCode
        }

        if let body = String(data: data, encoding: .utf8) {
            print("""
            ☀️ Response for \"\(request.description)\":
            👀 Status: \(httpResponse.statusCode)
            🧍‍♂️ Body:
            \(body)
            """)
        }

        return data
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)
        let object = try decoder.decode(T.self, from: data)

        return object
    }
}


