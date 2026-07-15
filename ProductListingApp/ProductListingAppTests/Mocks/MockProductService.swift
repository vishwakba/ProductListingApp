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
    var lastSearchLimit: Int?
    var lastSearchSkip: Int?
    var stubbedFetchProductsResult: Result<ProductResponse, Error> = .success(.mock)
    var stubbedSearchProductsResult: Result<ProductResponse, Error> = .success(.mock)

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
        lastSearchLimit = limit
        lastSearchSkip = skip
        return try stubbedSearchProductsResult.get()
    }
}

// MARK: - Test Helpers

extension ProductResponse {
    static let mock = ProductResponse(
        limit: 10,
        products: [.mock, .mockSecond],
        skip: 0,
        total: 194
    )

    static let mockEmpty = ProductResponse(
        limit: 10,
        products: [],
        skip: 0,
        total: 0
    )

    static let mockLastPage = ProductResponse(
        limit: 10,
        products: [.mock],
        skip: 190,
        total: 194
    )

    static let mockSinglePage = ProductResponse(
        limit: 10,
        products: [.mock, .mockSecond],
        skip: 0,
        total: 2
    )
}

extension Product {
    static let mock = Product(
        availabilityStatus: "In Stock",
        brand: "Essence",
        category: "beauty",
        description: "A popular mascara known for its volumizing effects.",
        dimensions: Dimensions(depth: 22.99, height: 13.08, width: 15.14),
        discountPercentage: 10.48,
        id: 1,
        images: ["https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp"],
        meta: ProductMeta(
            barcode: "5784719087687",
            createdAt: "2025-04-30T09:41:02.053Z",
            qrCode: "https://cdn.dummyjson.com/public/qr-code.png",
            updatedAt: "2025-04-30T09:41:02.053Z"
        ),
        minimumOrderQuantity: 48,
        price: 9.99,
        rating: 2.56,
        returnPolicy: "No return policy",
        reviews: [.mock],
        shippingInformation: "Ships in 3-5 business days",
        sku: "BEA-ESS-ESS-001",
        stock: 99,
        tags: ["beauty", "mascara"],
        thumbnail: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp",
        title: "Essence Mascara Lash Princess",
        warrantyInformation: "1 week warranty",
        weight: 4
    )

    static let mockSecond = Product(
        availabilityStatus: "Low Stock",
        brand: "Glamour Beauty",
        category: "electronics",
        description: "The Eyeshadow Palette with Mirror offers a versatile range.",
        dimensions: Dimensions(depth: 2.0, height: 8.0, width: 12.0),
        discountPercentage: 5.5,
        id: 2,
        images: ["https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/1.webp"],
        meta: ProductMeta(
            barcode: "1234567890123",
            createdAt: "2025-04-30T09:41:02.053Z",
            qrCode: "https://cdn.dummyjson.com/public/qr-code.png",
            updatedAt: "2025-04-30T09:41:02.053Z"
        ),
        minimumOrderQuantity: 10,
        price: 19.99,
        rating: 4.12,
        returnPolicy: "30 days return policy",
        reviews: [],
        shippingInformation: "Ships in 1-2 business days",
        sku: "BEA-GLA-EYE-001",
        stock: 5,
        tags: ["beauty", "eyeshadow"],
        thumbnail: "https://cdn.dummyjson.com/product-images/beauty/eyeshadow-palette-with-mirror/thumbnail.webp",
        title: "Eyeshadow Palette with Mirror",
        warrantyInformation: "1 month warranty",
        weight: 3
    )
}

extension Review {
    static let mock = Review(
        comment: "Would not recommend!",
        date: "2025-04-30T09:41:02.053Z",
        rating: 3,
        reviewerEmail: "eleanor.collins@x.dummyjson.com",
        reviewerName: "Eleanor Collins"
    )
}
