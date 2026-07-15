import Foundation

public final class ProductService: ProductServiceProtocol, Sendable {

    // MARK: - Properties

    private let apiClient: APIClientProtocol

    // MARK: - Initializer

    public init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    // MARK: - Public Methods

    public func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse {
        try await apiClient.request(.products(limit: limit, skip: skip))
    }

    public func searchProducts(query: String, limit: Int, skip: Int) async throws -> ProductResponse {
        try await apiClient.request(.searchProducts(query: query, limit: limit, skip: skip))
    }
}
