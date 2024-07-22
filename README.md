# APIManager

`APIManager` is a Swift package for handling network requests. It provides a simple interface for making HTTP GET, POST, PUT, and DELETE requests, and handling JSON responses :).

## Features

- Configurable base URL.
- Support for GET, POST, PUT, and DELETE requests.
- Flexible response handling with support for empty responses.
- Error handling for common network and decoding errors.

## Installation

### Swift Package Manager

To install `APIManager` using Swift Package Manager, add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/arodriguezp2003/swiftpackage-apimanager.git", from: "1.0.0")
]
```

Then, include `APIManager` as a dependency for your target:

```swift
.target(
    name: "YourTarget",
    dependencies: ["APIManager"]
)
```

## Usage

### Configuration

Before making any requests, configure the `APIManager` with your base URL:

```swift
import APIManager

APIManager.shared.configure(baseURL: "https://api.yourservice.com")
```

### Making Requests

#### GET Request

```swift
struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

APIManager.shared.get(path: "users/1") { (result: Result<User, APIError>) in
    switch result {
    case .success(let user):
        print("Fetched user: \(user)")
    case .failure(let error):
        print("Error fetching user: \(error.description)")
    }
}
```

#### POST Request

```swift
struct CreateUserRequest: Encodable {
    let name: String
    let email: String
}

APIManager.shared.post(path: "users", body: CreateUserRequest(name: "John Doe", email: "john.doe@example.com")) { (result: Result<User, APIError>) in
    switch result {
    case .success(let user):
        print("Created user: \(user)")
    case .failure(let error):
        print("Error creating user: \(error.description)")
    }
}
```

#### PUT Request

```swift
struct UpdateUserRequest: Encodable {
    let name: String
    let email: String
}

APIManager.shared.put(path: "users/1", body: UpdateUserRequest(name: "John Doe", email: "john.doe@updated.com")) { (result: Result<User, APIError>) in
    switch result {
    case .success(let user):
        print("Updated user: \(user)")
    case .failure(let error):
        print("Error updating user: \(error.description)")
    }
}
```

#### DELETE Request

For DELETE requests, if no content is expected in the response, use the `EmptyResponse` type:

```swift
APIManager.shared.delete(path: "users/1") { (result: Result<EmptyResponse, APIError>) in
    switch result {
    case .success:
        print("User deleted successfully")
    case .failure(let error):
        print("Error deleting user: \(error.description)")
    }
}
```

## Error Handling

`APIManager` provides detailed error handling with the `APIError` enum:

```swift
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
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
