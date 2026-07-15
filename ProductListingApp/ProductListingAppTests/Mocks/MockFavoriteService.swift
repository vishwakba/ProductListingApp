import Foundation
import SwiftData
@testable import AppCore

@MainActor
final class MockFavoriteService: FavoriteServiceProtocol, @unchecked Sendable {

    // MARK: - Properties

    var isFavoriteResult = false
    var toggleFavoriteResult = true
    var toggleFavoriteCalled = false
    var lastToggledProductId: Int?

    // MARK: - FavoriteServiceProtocol

    func isFavorite(productId: Int, modelContext: ModelContext) -> Bool {
        isFavoriteResult
    }

    func toggleFavorite(productId: Int, title: String, modelContext: ModelContext) -> Bool {
        toggleFavoriteCalled = true
        lastToggledProductId = productId
        return toggleFavoriteResult
    }
}
