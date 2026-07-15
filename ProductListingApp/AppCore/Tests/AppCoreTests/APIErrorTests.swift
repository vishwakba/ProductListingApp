import XCTest
@testable import AppCore

final class APIErrorTests: XCTestCase {

    // MARK: - Error Description Tests

    func test_decodingError_description_containsMessage() {
        // Arrange
        let error = APIError.decodingError("Missing key")

        // Act
        let description = error.errorDescription

        // Assert
        XCTAssertNotNil(description)
        XCTAssertTrue(description!.contains("Missing key"))
    }

    func test_invalidResponse_description_isNotNil() {
        // Arrange
        let error = APIError.invalidResponse

        // Act
        let description = error.errorDescription

        // Assert
        XCTAssertNotNil(description)
    }

    func test_invalidURL_description_isNotNil() {
        // Arrange
        let error = APIError.invalidURL

        // Act
        let description = error.errorDescription

        // Assert
        XCTAssertNotNil(description)
    }

    func test_networkError_description_containsMessage() {
        // Arrange
        let error = APIError.networkError("No connection")

        // Act
        let description = error.errorDescription

        // Assert
        XCTAssertNotNil(description)
        XCTAssertTrue(description!.contains("No connection"))
    }

    func test_serverError_description_containsStatusCode() {
        // Arrange
        let error = APIError.serverError(statusCode: 500)

        // Act
        let description = error.errorDescription

        // Assert
        XCTAssertNotNil(description)
        XCTAssertTrue(description!.contains("500"))
    }

    func test_unauthorized_description_isNotNil() {
        // Arrange
        let error = APIError.unauthorized

        // Act
        let description = error.errorDescription

        // Assert
        XCTAssertNotNil(description)
    }

    func test_unknown_description_isNotNil() {
        // Arrange
        let error = APIError.unknown

        // Act
        let description = error.errorDescription

        // Assert
        XCTAssertNotNil(description)
    }

    // MARK: - Equality Tests

    func test_decodingError_equatable_sameMessage_areEqual() {
        // Arrange
        let error1 = APIError.decodingError("key missing")
        let error2 = APIError.decodingError("key missing")

        // Act & Assert
        XCTAssertEqual(error1, error2)
    }

    func test_serverError_equatable_differentCodes_areNotEqual() {
        // Arrange
        let error1 = APIError.serverError(statusCode: 500)
        let error2 = APIError.serverError(statusCode: 404)

        // Act & Assert
        XCTAssertNotEqual(error1, error2)
    }
}
