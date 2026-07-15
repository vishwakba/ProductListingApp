import Foundation

public struct ProductResponse: Codable, Equatable, Sendable {

    // MARK: - Properties

    public let limit: Int
    public let products: [Product]
    public let skip: Int
    public let total: Int
}
