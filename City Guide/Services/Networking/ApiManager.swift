//
//  ApiManager.swift
//  City Guide
//
//  Created by Martin Vidovic on 17.04.2023.
//

import Foundation

protocol APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class APIManager {
    // decoder for decoding objects
    private let decoder = JSONDecoder()
    
    // session for downloading
    private let urlSession = URLSession.shared
    
    private func request(_ endpoint: Endpoint) async throws -> Data {
        /// from `Endpoint` protocol we receive finished URLRequest
        let request: URLRequest = try endpoint.asRequest()
        
        // print it to log
        print("🚀 Request for \"\(request.description)\"")

        // fire request -> get data + URLResponse from request
        let (data, response) = try await urlSession.data(for: request)
        
        // unwrap HTTPResponse
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noResponse
        }
        
        // check for acceptable status code
        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.unacceptableResponseStatusCode
        }
        
        // decode data for log
        if let body = String(data: data, encoding: .utf8) {
            print("Body of request: \(body)")
        }

        return data
    }
}

// MARK: APIManaging

extension APIManager: APIManaging {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)
        let object = try decoder.decode(T.self, from: data)

        return object
    }
}
