//
//  File.swift
//  
//
//  Created by Alejandro  Rodriguez on 21-07-24.
//

import Foundation

public protocol APIService {
    func get<T: Decodable>(path: String, completion: @escaping (Result<T, APIError>) -> Void)
    func post<T: Decodable, U: Encodable>(path: String, body: U, completion: @escaping (Result<T, APIError>) -> Void)
    func put<T: Decodable, U: Encodable>(path: String, body: U, completion: @escaping (Result<T, APIError>) -> Void)
    func delete<T: Decodable>(path: String, completion: @escaping (Result<T, APIError>) -> Void)
}
