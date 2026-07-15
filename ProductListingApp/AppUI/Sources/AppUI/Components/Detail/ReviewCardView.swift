import SwiftUI

public struct ReviewCardView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let comment: String
    private let date: String
    private let rating: Int
    private let reviewerName: String

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        comment: String,
        date: String,
        rating: Int,
        reviewerName: String
    ) {
        self.accessibilityID = accessibilityID
        self.comment = comment
        self.date = date
        self.rating = rating
        self.reviewerName = reviewerName
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 2) {
                    Text(reviewerName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(formattedDate)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                }
            }

            Text(comment)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
        .accessibilityIdentifier(accessibilityID)
    }
}

// MARK: - Private Helpers

private extension ReviewCardView {
    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let parsedDate = formatter.date(from: date) else { return date }
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        return displayFormatter.string(from: parsedDate)
    }
}

#Preview {
    ReviewCardView(
        accessibilityID: "preview_review",
        comment: "Great product, highly recommended!",
        date: "2025-04-30T09:41:02.053Z",
        rating: 4,
        reviewerName: "John Doe"
    )
    .padding()
}
