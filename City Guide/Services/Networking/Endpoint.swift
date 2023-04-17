//
//  Endpoint.swift
//  City Guide
//
//  Created by Martin Vidovic on 17.04.2023.
//

import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var urlParameters: [String: Any]? { get }
    var headers: [String: String]? { get }

    func asRequest() throws -> URLRequest
}

extension Endpoint {
    func asRequest() throws -> URLRequest {
        // base url
        let baseURL =  URL(string: baseURL)!
        // add path
        let urlPath = baseURL.appendingPathComponent(path)

        // create URLComponents for adding more components (parts)
        guard var urlComponents = URLComponents(url: urlPath, resolvingAgainstBaseURL: true) else {
            throw APIError.invalidUrlComponents
        }

        // add query parameters behind path
        if let urlParameters = urlParameters {
            urlComponents.queryItems = urlParameters.map { URLQueryItem(name: $0, value: String(describing: $1)) }
        }

        // get URL from URLComponents
        guard let url = urlComponents.url else {
            throw APIError.invalidUrlComponents
        }

        // create final request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        return request
    }
}
