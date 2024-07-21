//
//  File.swift
//  
//
//  Created by Alejandro  Rodriguez on 21-07-24.
//

import Foundation
/**
     Provides a human-readable description of the error.
*/
public enum APIError: Error, CustomStringConvertible {
    case invalidURL
    case noData
    case decodingError(Error, Data?)
    case networkError(Error)
    case httpError(Int, String?)
    case unauthorized
    case unknownError

    public var description: String {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingError(let error, let data):
            var message = "There was an error decoding the data: \(error.localizedDescription)"
            if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                message += "\nFailed JSON: \(jsonString)"
            }
            return message
        case .networkError(let error):
            return "There was a network error: \(error.localizedDescription)"
        case .httpError(let statusCode, let message):
            return "HTTP error with status code: \(statusCode). Message: \(message ?? "No message available")"
        case .unauthorized:
            return "Session expired. Please log in again."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
