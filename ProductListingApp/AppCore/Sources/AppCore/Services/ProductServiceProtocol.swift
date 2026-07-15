import Foundation

public protocol ProductServiceProtocol: Sendable {
    func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse
    func searchProducts(query: String, limit: Int, skip: Int) async throws -> ProductResponse
}
