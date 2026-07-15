import AppCore
import SwiftData
import SwiftUI

@main
struct ProductListingApp: App {

    // MARK: - Properties

    private let favoriteService: FavoriteServiceProtocol
    private let productService: ProductServiceProtocol

    // MARK: - Initializer

    init() {
        self.favoriteService = FavoriteService()
        self.productService = ProductService()
    }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ProductListView(favoriteService: favoriteService, productService: productService)
        }
        .modelContainer(for: FavoriteProduct.self)
    }
}
