import Foundation

public class APIManager: APIService {
    public static let shared: APIService = APIManager()
    
    private var baseURL: URL?
    
    private init() {}
    
    /**
     Configures the API manager with a base URL.
     
     - Parameter baseURL: The base URL for the API.
     */
    public func configure(baseURL: String) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL")
        }
        self.baseURL = url
    }
    
    /**
     Creates a full URL by appending the given path to the base URL.
     
     - Parameter path: The path to append to the base URL.
     - Returns: A full URL if the base URL and path are valid, otherwise nil.
     */
    private func createURL(path: String) -> URL? {
        return baseURL?.appendingPathComponent(path)
    }
    
    /**
     Handles the response from a network request, decoding the data into the specified type.
     
     - Parameters:
        - result: The result of the network request, containing either the data or an error.
        - completion: A closure to call with the decoded result or an error.
     */
    private func handleResponse<T: Decodable>(_ result: Result<Data, APIError>, completion: @escaping (Result<T, APIError>) -> Void) {
        switch result {
        case .success(let data):
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch let decodingError {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(decodingError, data)))
                }
            }
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    /**
     Makes a network request to the specified path with the given HTTP method and request body.
     
     - Parameters:
        - path: The path for the API request.
        - method: The HTTP method to use (GET, POST, PUT, DELETE).
        - body: The request body data, if any.
        - completion: A closure to call with the result of the request.
     */
    private func request<T: Decodable>(path: String, method: HttpMethod, body: Data? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = createURL(path: path) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        DispatchQueue.global(qos: .background).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    self.handleResponse(.failure(.networkError(error)), completion: completion)
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 401 {
                        self.handleResponse(.failure(.unauthorized), completion: completion)
                        return
                    } else if !(200...299).contains(response.statusCode) {
                        let message = data.flatMap { String(data: $0, encoding: .utf8) }
                        self.handleResponse(.failure(.httpError(response.statusCode, message)), completion: completion)
                        return
                    }
                }
                
                guard let data = data else {
                    self.handleResponse(.failure(.noData), completion: completion)
                    return
                }
                
                self.handleResponse(.success(data), completion: completion)
            }
            
            task.resume()
        }
    }
    
    /**
     Makes a GET request to the specified path.
     
     - Parameters:
        - path: The path for the API request.
        - completion: A closure to call with the result of the request.
     */
    public func get<T: Decodable>(path: String, completion: @escaping (Result<T, APIError>) -> Void) {
        request(path: path, method: .GET, completion: completion)
    }
    
    /**
     Makes a POST request to the specified path with the given request body.
     
     - Parameters:
        - path: The path for the API request.
        - body: The request body data.
        - completion: A closure to call with the result of the request.
     */
    public func post<T: Decodable, U: Encodable>(path: String, body: U, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let bodyData = try JSONEncoder().encode(body)
            request(path: path, method: .POST, body: bodyData, completion: completion)
        } catch let encodingError {
            completion(.failure(.decodingError(encodingError, nil)))
        }
    }
    
    /**
     Makes a PUT request to the specified path with the given request body.
     
     - Parameters:
        - path: The path for the API request.
        - body: The request body data.
        - completion: A closure to call with the result of the request.
     */
    public func put<T: Decodable, U: Encodable>(path: String, body: U, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let bodyData = try JSONEncoder().encode(body)
            request(path: path, method: .PUT, body: bodyData, completion: completion)
        } catch let encodingError {
            completion(.failure(.decodingError(encodingError, nil)))
        }
    }
    
    /**
     Makes a DELETE request to the specified path.
     
     - Parameters:
        - path: The path for the API request.
        - completion: A closure to call with the result of the request.
     */
    public func delete<T: Decodable>(path: String, completion: @escaping (Result<T, APIError>) -> Void) {
        request(path: path, method: .DELETE, completion: completion)
    }
}

public enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
