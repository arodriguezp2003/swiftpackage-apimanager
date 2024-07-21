//
//  File.swift
//  
//
//  Created by Alejandro  Rodriguez on 21-07-24.
//

import Foundation

public protocol APIService {
    /**
     Configures the API manager with a base URL.
     
     - Parameter baseURL: The base URL for the API.
     */
    func configure(baseURL: String)
    
    /**
     Makes a GET request to the specified path.
     
     - Parameters:
        - path: The path for the API request.
        - completion: A closure to call with the result of the request.
     */
    func get<T: Decodable>(path: String, completion: @escaping (Result<T, APIError>) -> Void)
    
    /**
     Makes a POST request to the specified path with the given request body.
     
     - Parameters:
        - path: The path for the API request.
        - body: The request body data.
        - completion: A closure to call with the result of the request.
     */
    func post<T: Decodable, U: Encodable>(path: String, body: U, completion: @escaping (Result<T, APIError>) -> Void)
    
    /**
     Makes a PUT request to the specified path with the given request body.
     
     - Parameters:
        - path: The path for the API request.
        - body: The request body data.
        - completion: A closure to call with the result of the request.
     */
    func put<T: Decodable, U: Encodable>(path: String, body: U, completion: @escaping (Result<T, APIError>) -> Void)
    
    /**
     Makes a DELETE request to the specified path.
     
     - Parameters:
        - path: The path for the API request.
        - completion: A closure to call with the result of the request.
     */
    func delete<T: Decodable>(path: String, completion: @escaping (Result<T, APIError>) -> Void)
}
