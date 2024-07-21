import XCTest
@testable import APIManager

final class APIManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Configurar la base URL antes de cada prueba
        APIManager.shared.configure(baseURL: "https://jsonplaceholder.typicode.com")
    }
    
    func testGetRequest() {
        let expectation = self.expectation(description: "Fetching user")
        
        APIManager.shared.get(path: "users/1") { (result: Result<User, APIError>) in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.id, 1)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error fetching user: \(error.description)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPostRequest() {
        let expectation = self.expectation(description: "Creating user")
        let newUser = CreateUserRequest(name: "Jane Doe", email: "jane.doe@example.com")
        
        APIManager.shared.post(path: "users", body: newUser) { (result: Result<User, APIError>) in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.name, "Jane Doe")
                XCTAssertEqual(user.email, "jane.doe@example.com")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error creating user: \(error.description)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPutRequest() {
        let expectation = self.expectation(description: "Updating user")
        let updatedUser = UpdateUserRequest(name: "John Doe", email: "john.doe@updatedexample.com")
        
        APIManager.shared.put(path: "users/1", body: updatedUser) { (result: Result<User, APIError>) in
            switch result {
            case .success(let user):
                XCTAssertEqual(user.name, "John Doe")
                XCTAssertEqual(user.email, "john.doe@updatedexample.com")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error updating user: \(error.description)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeleteRequest() {
        let expectation = self.expectation(description: "Deleting user")
        
        APIManager.shared.delete(path: "users/1") { (result: Result<EmptyResponse, APIError>) in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Error deleting user: \(error.description)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    struct User: Decodable {
        let id: Int
        let name: String
        let email: String
    }
    
    struct CreateUserRequest: Encodable {
        let name: String
        let email: String
    }
    
    struct UpdateUserRequest: Encodable {
        let name: String
        let email: String
    }
    
}
