import Foundation
import SwiftData

public protocol FavoriteServiceProtocol: Sendable {
    @MainActor func isFavorite(productId: Int, modelContext: ModelContext) -> Bool
    @MainActor func toggleFavorite(productId: Int, title: String, modelContext: ModelContext) -> Bool
}
