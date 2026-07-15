import Foundation
import SwiftData

public final class FavoriteService: FavoriteServiceProtocol, Sendable {

    // MARK: - Initializer

    public init() {}

    // MARK: - Public Methods

    @MainActor
    public func isFavorite(productId: Int, modelContext: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<FavoriteProduct>(
            predicate: #Predicate { $0.productId == productId }
        )
        return (try? modelContext.fetchCount(descriptor)) ?? 0 > 0
    }

    @MainActor
    public func toggleFavorite(productId: Int, title: String, modelContext: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<FavoriteProduct>(
            predicate: #Predicate { $0.productId == productId }
        )

        if let existing = try? modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
            return false
        } else {
            let favorite = FavoriteProduct(productId: productId, title: title)
            modelContext.insert(favorite)
            return true
        }
    }
}
