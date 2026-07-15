import XCTest
@testable import AppCore

final class ProductServiceTests: XCTestCase {

    // MARK: - Properties

    private var mockAPIClient: MockAPIClient!
    private var sut: ProductService!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        sut = ProductService(apiClient: mockAPIClient)
    }

    override func tearDown() {
        mockAPIClient = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - FetchProducts Tests

    func test_fetchProducts_success_returnsProductResponse() async throws {
        // Arrange
        mockAPIClient.stubbedData = sampleProductJSON

        // Act
        let response = try await sut.fetchProducts(limit: 10, skip: 0)

        // Assert
        XCTAssertEqual(response.products.count, 2)
        XCTAssertEqual(response.total, 194)
        XCTAssertEqual(response.skip, 0)
        XCTAssertEqual(response.limit, 10)
        XCTAssertTrue(mockAPIClient.requestCalled)
        XCTAssertEqual(mockAPIClient.requestCallCount, 1)
    }

    func test_fetchProducts_success_decodesFirstProductCorrectly() async throws {
        // Arrange
        mockAPIClient.stubbedData = sampleProductJSON

        // Act
        let response = try await sut.fetchProducts(limit: 10, skip: 0)

        // Assert
        let product = response.products[0]
        XCTAssertEqual(product.id, 1)
        XCTAssertEqual(product.title, "Essence Mascara Lash Princess")
        XCTAssertEqual(product.category, "beauty")
        XCTAssertEqual(product.price, 9.99)
        XCTAssertEqual(product.discountPercentage, 10.48)
        XCTAssertEqual(product.rating, 2.56)
        XCTAssertEqual(product.stock, 99)
        XCTAssertEqual(product.brand, "Essence")
        XCTAssertEqual(product.availabilityStatus, "In Stock")
        XCTAssertEqual(product.tags, ["beauty", "mascara"])
    }

    func test_fetchProducts_success_decodesReviewsCorrectly() async throws {
        // Arrange
        mockAPIClient.stubbedData = sampleProductJSON

        // Act
        let response = try await sut.fetchProducts(limit: 10, skip: 0)

        // Assert
        let reviews = response.products[0].reviews
        XCTAssertEqual(reviews.count, 1)
        XCTAssertEqual(reviews[0].rating, 3)
        XCTAssertEqual(reviews[0].comment, "Would not recommend!")
        XCTAssertEqual(reviews[0].reviewerName, "Eleanor Collins")
    }

    func test_fetchProducts_success_decodesDimensionsCorrectly() async throws {
        // Arrange
        mockAPIClient.stubbedData = sampleProductJSON

        // Act
        let response = try await sut.fetchProducts(limit: 10, skip: 0)

        // Assert
        let dimensions = response.products[0].dimensions
        XCTAssertEqual(dimensions.width, 15.14)
        XCTAssertEqual(dimensions.height, 13.08)
        XCTAssertEqual(dimensions.depth, 22.99)
    }

    func test_fetchProducts_success_passesCorrectEndpoint() async throws {
        // Arrange
        mockAPIClient.stubbedData = sampleProductJSON

        // Act
        _ = try await sut.fetchProducts(limit: 10, skip: 20)

        // Assert
        XCTAssertEqual(mockAPIClient.lastRequestedEndpoint, .products(limit: 10, skip: 20))
    }

    func test_fetchProducts_networkError_throwsError() async {
        // Arrange
        mockAPIClient.stubbedError = APIError.networkError("No internet connection")

        // Act & Assert
        do {
            _ = try await sut.fetchProducts(limit: 10, skip: 0)
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .networkError("No internet connection"))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_fetchProducts_decodingError_throwsError() async {
        // Arrange
        mockAPIClient.stubbedData = "invalid json".data(using: .utf8)

        // Act & Assert
        do {
            let _: ProductResponse = try await sut.fetchProducts(limit: 10, skip: 0)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(mockAPIClient.requestCalled)
        }
    }

    func test_fetchProducts_serverError_throwsError() async {
        // Arrange
        mockAPIClient.stubbedError = APIError.serverError(statusCode: 500)

        // Act & Assert
        do {
            _ = try await sut.fetchProducts(limit: 10, skip: 0)
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .serverError(statusCode: 500))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_fetchProducts_unauthorized_throwsError() async {
        // Arrange
        mockAPIClient.stubbedError = APIError.unauthorized

        // Act & Assert
        do {
            _ = try await sut.fetchProducts(limit: 10, skip: 0)
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_fetchProducts_emptyResponse_returnsEmptyProducts() async throws {
        // Arrange
        mockAPIClient.stubbedData = sampleEmptyResponseJSON

        // Act
        let response = try await sut.fetchProducts(limit: 10, skip: 0)

        // Assert
        XCTAssertTrue(response.products.isEmpty)
        XCTAssertEqual(response.total, 0)
    }

    // MARK: - SearchProducts Tests

    func test_searchProducts_success_returnsResults() async throws {
        // Arrange
        mockAPIClient.stubbedData = sampleProductJSON

        // Act
        let response = try await sut.searchProducts(query: "mascara", limit: 10, skip: 0)

        // Assert
        XCTAssertEqual(response.products.count, 2)
        XCTAssertTrue(mockAPIClient.requestCalled)
    }

    func test_searchProducts_success_passesCorrectEndpoint() async throws {
        // Arrange
        mockAPIClient.stubbedData = sampleProductJSON

        // Act
        _ = try await sut.searchProducts(query: "phone", limit: 10, skip: 0)

        // Assert
        XCTAssertEqual(mockAPIClient.lastRequestedEndpoint, .searchProducts(query: "phone", limit: 10, skip: 0))
    }

    func test_searchProducts_networkError_throwsError() async {
        // Arrange
        mockAPIClient.stubbedError = APIError.networkError("Timeout")

        // Act & Assert
        do {
            _ = try await sut.searchProducts(query: "test", limit: 10, skip: 0)
            XCTFail("Expected error to be thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, .networkError("Timeout"))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func test_searchProducts_emptyQuery_returnsResults() async throws {
        // Arrange
        mockAPIClient.stubbedData = sampleEmptyResponseJSON

        // Act
        let response = try await sut.searchProducts(query: "", limit: 10, skip: 0)

        // Assert
        XCTAssertTrue(response.products.isEmpty)
    }
}
