import AppCore
import Combine
import Foundation
import SwiftData

@MainActor
final class ProductDetailViewModel: ObservableObject {

    // MARK: - Properties

    @Published private(set) var isFavorite = false
    let product: Product

    private let favoriteService: FavoriteServiceProtocol

    // MARK: - Initializer

    init(
        favoriteService: FavoriteServiceProtocol = FavoriteService(),
        product: Product
    ) {
        self.favoriteService = favoriteService
        self.product = product
    }

    // MARK: - Computed Properties

    var availabilityColor: String {
        switch product.availabilityStatus {
        case "In Stock": return "green"
        case "Low Stock": return "orange"
        default: return "red"
        }
    }

    var discountedPriceFormatted: String {
        String(format: "$%.2f", product.discountedPrice)
    }

    var dimensionsFormatted: String {
        String(format: "%.1f × %.1f × %.1f cm", product.dimensions.width, product.dimensions.height, product.dimensions.depth)
    }

    var hasDiscount: Bool {
        product.discountPercentage > 0
    }

    var hasReviews: Bool {
        !product.reviews.isEmpty
    }

    var originalPriceFormatted: String {
        String(format: "$%.2f", product.price)
    }

    var weightFormatted: String {
        "\(product.weight) g"
    }

    // MARK: - Public Methods

    func checkFavoriteStatus(modelContext: ModelContext) {
        isFavorite = favoriteService.isFavorite(productId: product.id, modelContext: modelContext)
    }

    func toggleFavorite(modelContext: ModelContext) {
        isFavorite = favoriteService.toggleFavorite(
            productId: product.id,
            title: product.title,
            modelContext: modelContext
        )
    }
}
