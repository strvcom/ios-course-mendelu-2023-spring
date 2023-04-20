//
//  APIManager.swift
//  City Guide
//
//  Created by Martin Vidovic on 19.04.2023.
//

import Foundation

protocol ApiManaging {
    func request<T: Decodable>(_ request: URLRequest) async throws -> T
}

final class APIManager: ApiManaging {
    private let session: URLSession = URLSession.shared
    private let decoder = JSONDecoder()
    
    func request<T>(_ request: URLRequest) async throws -> T where T : Decodable {
        print("RESPONSE: I send request \(request.description)")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.noHTTPResponse
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            throw APIError.badHTTPResponse
        }
        
        let result = try decoder.decode(T.self, from: data)
        
        print("RESPONSE: apimanager -> \(request.url) \(result)")
        return result
    }
}

enum APIError: Error {
    case noHTTPResponse
    case badHTTPResponse
}
