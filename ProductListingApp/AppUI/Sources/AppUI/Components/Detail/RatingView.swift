import SwiftUI

public struct RatingView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let maxRating: Int
    private let rating: Double

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        maxRating: Int = 5,
        rating: Double
    ) {
        self.accessibilityID = accessibilityID
        self.maxRating = maxRating
        self.rating = rating
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: starImageName(for: index))
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
        }
        .accessibilityIdentifier(accessibilityID)
    }
}

// MARK: - Private Helpers

private extension RatingView {
    func starImageName(for index: Int) -> String {
        if Double(index) <= rating {
            return "star.fill"
        } else if Double(index) - 0.5 <= rating {
            return "star.leadinghalf.filled"
        }
        return "star"
    }
}

#Preview {
    VStack {
        RatingView(accessibilityID: "preview_rating", rating: 3.7)
        RatingView(accessibilityID: "preview_rating_2", rating: 4.5)
        RatingView(accessibilityID: "preview_rating_3", rating: 1.0)
    }
}
