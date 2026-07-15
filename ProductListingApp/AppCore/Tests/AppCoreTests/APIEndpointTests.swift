import XCTest
@testable import AppCore

final class APIEndpointTests: XCTestCase {

    // MARK: - Products Endpoint Tests

    func test_products_url_containsCorrectPath() {
        // Arrange
        let endpoint = APIEndpoint.products(limit: 10, skip: 0)

        // Act
        let url = endpoint.url

        // Assert
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("/products"))
        XCTAssertTrue(url!.absoluteString.contains("limit=10"))
        XCTAssertTrue(url!.absoluteString.contains("skip=0"))
    }

    func test_products_url_withSkip_containsSkipParameter() {
        // Arrange
        let endpoint = APIEndpoint.products(limit: 10, skip: 20)

        // Act
        let url = endpoint.url

        // Assert
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("skip=20"))
    }

    func test_products_method_isGet() {
        // Arrange
        let endpoint = APIEndpoint.products(limit: 10, skip: 0)

        // Act
        let method = endpoint.method

        // Assert
        XCTAssertEqual(method, .get)
    }

    // MARK: - Search Endpoint Tests

    func test_searchProducts_url_containsSearchPath() {
        // Arrange
        let endpoint = APIEndpoint.searchProducts(query: "phone", limit: 10, skip: 0)

        // Act
        let url = endpoint.url

        // Assert
        XCTAssertNotNil(url)
        XCTAssertTrue(url!.absoluteString.contains("/products/search"))
        XCTAssertTrue(url!.absoluteString.contains("q=phone"))
    }

    func test_searchProducts_method_isGet() {
        // Arrange
        let endpoint = APIEndpoint.searchProducts(query: "test", limit: 10, skip: 0)

        // Act
        let method = endpoint.method

        // Assert
        XCTAssertEqual(method, .get)
    }

    // MARK: - Equality Tests

    func test_products_equatable_sameValues_areEqual() {
        // Arrange
        let endpoint1 = APIEndpoint.products(limit: 10, skip: 0)
        let endpoint2 = APIEndpoint.products(limit: 10, skip: 0)

        // Act & Assert
        XCTAssertEqual(endpoint1, endpoint2)
    }

    func test_products_equatable_differentValues_areNotEqual() {
        // Arrange
        let endpoint1 = APIEndpoint.products(limit: 10, skip: 0)
        let endpoint2 = APIEndpoint.products(limit: 10, skip: 10)

        // Act & Assert
        XCTAssertNotEqual(endpoint1, endpoint2)
    }
}
