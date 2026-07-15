import Kingfisher
import SwiftUI

public struct ProductCardView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let discountPercentage: Double
    private let isFavorite: Bool
    private let onFavoriteTap: () -> Void
    private let price: Double
    private let rating: Double
    private let thumbnailURL: URL?
    private let title: String

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        discountPercentage: Double,
        isFavorite: Bool,
        onFavoriteTap: @escaping () -> Void,
        price: Double,
        rating: Double,
        thumbnailURL: URL?,
        title: String
    ) {
        self.accessibilityID = accessibilityID
        self.discountPercentage = discountPercentage
        self.isFavorite = isFavorite
        self.onFavoriteTap = onFavoriteTap
        self.price = price
        self.rating = rating
        self.thumbnailURL = thumbnailURL
        self.title = title
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 12) {
            KFImage(thumbnailURL)
                .placeholder {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundStyle(.gray)
                        }
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 6) {
                    Text(formattedPrice)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)

                    if discountPercentage > 0 {
                        Text(formattedOriginalPrice)
                            .font(.caption)
                            .strikethrough()
                            .foregroundStyle(.secondary)

                        Text("-\(Int(discountPercentage))%")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.red, in: Capsule())
                    }
                }
            }

            Spacer()

            Button {
                onFavoriteTap()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundStyle(isFavorite ? .red : .gray)
                    .symbolEffect(.bounce, value: isFavorite)
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .contentShape(Rectangle())
        .accessibilityIdentifier(accessibilityID)
    }
}

// MARK: - Private Helpers

private extension ProductCardView {
    var discountedPrice: Double {
        price * (1 - discountPercentage / 100)
    }

    var formattedOriginalPrice: String {
        String(format: "$%.2f", price)
    }

    var formattedPrice: String {
        if discountPercentage > 0 {
            return String(format: "$%.2f", discountedPrice)
        }
        return String(format: "$%.2f", price)
    }
}

#Preview {
    ProductCardView(
        accessibilityID: "preview_card",
        discountPercentage: 10.48,
        isFavorite: false,
        onFavoriteTap: {},
        price: 9.99,
        rating: 4.5,
        thumbnailURL: nil,
        title: "Essence Mascara Lash Princess"
    )
    .padding()
}
