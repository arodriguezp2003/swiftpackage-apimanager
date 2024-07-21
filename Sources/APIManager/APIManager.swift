import Foundation

public class APIManager: APIService {
    public static let shared = APIManager()
    
    private var baseURL: URL
    
    // Inicializador privado para asegurar el uso de la base URL configurada
    private init() {
        guard let baseURL = URL(string: "https://jsonplaceholder.typicode.com") else {
            fatalError("Invalid base URL")
        }
        self.baseURL = baseURL
    }
    
    // Método público para configurar la base URL
    public func configure(baseURL: String) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL")
        }
        APIManager.shared.baseURL = url
    }
    
    private func createURL(path: String) -> URL? {
        return baseURL.appendingPathComponent(path)
    }
    
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as NSError?, error.domain == NSURLErrorDomain {
                completion(.failure(.networkError(error)))
                return
            }
            
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 401 {
                    completion(.failure(.unauthorized))
                    return
                } else if !(200...299).contains(response.statusCode) {
                    completion(.failure(.httpError(response.statusCode)))
                    return
                }
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            print(String(data: data, encoding: .utf8))
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch let decodingError {
                completion(.failure(.decodingError(decodingError)))
            }
        }
        
        task.resume()
    }
    
    public func get<T: Decodable>(path: String, completion: @escaping (Result<T, APIError>) -> Void) {
        request(path: path, method: .GET, completion: completion)
    }
    
    public func post<T: Decodable, U: Encodable>(path: String, body: U, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let bodyData = try JSONEncoder().encode(body)
            request(path: path, method: .POST, body: bodyData, completion: completion)
        } catch let encodingError {
            completion(.failure(.decodingError(encodingError)))
        }
    }
    
    public func put<T: Decodable, U: Encodable>(path: String, body: U, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let bodyData = try JSONEncoder().encode(body)
            request(path: path, method: .PUT, body: bodyData, completion: completion)
        } catch let encodingError {
            completion(.failure(.decodingError(encodingError)))
        }
    }
    
    public func delete<T: Decodable>(path: String, completion: @escaping (Result<T, APIError>) -> Void) {
        request(path: path, method: .DELETE, completion: completion)
    }
}

enum HttpMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

