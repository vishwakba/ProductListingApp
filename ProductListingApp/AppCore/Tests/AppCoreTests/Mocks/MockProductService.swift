import Foundation
@testable import AppCore

final class MockProductService: ProductServiceProtocol, @unchecked Sendable {

    // MARK: - Properties

    var fetchProductsCallCount = 0
    var fetchProductsCalled = false
    var lastFetchLimit: Int?
    var lastFetchSkip: Int?
    var searchProductsCallCount = 0
    var searchProductsCalled = false
    var lastSearchQuery: String?
    var stubbedFetchProductsResult: Result<ProductResponse, Error> = .success(ProductResponse.mock)
    var stubbedSearchProductsResult: Result<ProductResponse, Error> = .success(ProductResponse.mock)

    // MARK: - ProductServiceProtocol

    func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse {
        fetchProductsCalled = true
        fetchProductsCallCount += 1
        lastFetchLimit = limit
        lastFetchSkip = skip
        return try stubbedFetchProductsResult.get()
    }

    func searchProducts(query: String, limit: Int, skip: Int) async throws -> ProductResponse {
        searchProductsCalled = true
        searchProductsCallCount += 1
        lastSearchQuery = query
        return try stubbedSearchProductsResult.get()
    }
}
