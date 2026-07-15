import Foundation
import SwiftData

@Model
public final class FavoriteProduct {

    // MARK: - Properties

    public var addedAt: Date
    @Attribute(.unique) public var productId: Int
    public var title: String

    // MARK: - Initializer

    public init(
        addedAt: Date = .now,
        productId: Int,
        title: String
    ) {
        self.addedAt = addedAt
        self.productId = productId
        self.title = title
    }
}
