import Foundation

public struct Product: Codable, Identifiable, Equatable, Hashable, Sendable {

    // MARK: - Properties

    public let availabilityStatus: String
    public let brand: String?
    public let category: String
    public let description: String
    public let dimensions: Dimensions
    public let discountPercentage: Double
    public let id: Int
    public let images: [String]
    public let meta: ProductMeta
    public let minimumOrderQuantity: Int
    public let price: Double
    public let rating: Double
    public let returnPolicy: String
    public let reviews: [Review]
    public let shippingInformation: String
    public let sku: String
    public let stock: Int
    public let tags: [String]
    public let thumbnail: String
    public let title: String
    public let warrantyInformation: String
    public let weight: Int
}

// MARK: - Nested Types

public struct Dimensions: Codable, Equatable, Hashable, Sendable {
    public let depth: Double
    public let height: Double
    public let width: Double
}

public struct ProductMeta: Codable, Equatable, Hashable, Sendable {
    public let barcode: String
    public let createdAt: String
    public let qrCode: String
    public let updatedAt: String
}

public struct Review: Codable, Identifiable, Equatable, Hashable, Sendable {
    public let comment: String
    public let date: String
    public let rating: Int
    public let reviewerEmail: String
    public let reviewerName: String

    public var id: String { "\(reviewerEmail)_\(date)" }

    enum CodingKeys: String, CodingKey {
        case comment
        case date
        case rating
        case reviewerEmail
        case reviewerName
    }
}

// MARK: - Computed Properties

public extension Product {
    var discountedPrice: Double {
        price * (1 - discountPercentage / 100)
    }

    var imageURLs: [URL] {
        images.compactMap { URL(string: $0) }
    }

    var thumbnailURL: URL? {
        URL(string: thumbnail)
    }
}
