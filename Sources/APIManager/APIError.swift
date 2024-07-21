//
//  File.swift
//  
//
//  Created by Alejandro  Rodriguez on 21-07-24.
//

import Foundation
public enum APIError: Error, CustomStringConvertible {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case httpError(Int)
    case unauthorized
    case unknownError

    public var description: String {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingError(let error):
            return "There was an error decoding the data: \(error.localizedDescription)"
        case .networkError(let error):
            return "There was a network error: \(error.localizedDescription)"
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)"
        case .unauthorized:
            return "Session expired. Please log in again."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
