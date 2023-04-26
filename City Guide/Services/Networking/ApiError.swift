//
//  ApiError.swift
//  City Guide
//
//  Created by Martin Vidovic on 17.04.2023.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidUrlComponents
    case noResponse
    case unacceptableResponseStatusCode
    case customDecodingFailed
    case malformedUrl
}
