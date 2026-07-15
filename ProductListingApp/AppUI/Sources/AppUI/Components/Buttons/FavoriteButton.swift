import SwiftUI

public struct FavoriteButton: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let isFavorite: Bool
    private let onToggle: () -> Void

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        isFavorite: Bool,
        onToggle: @escaping () -> Void
    ) {
        self.accessibilityID = accessibilityID
        self.isFavorite = isFavorite
        self.onToggle = onToggle
    }

    // MARK: - Body

    public var body: some View {
        Button(action: onToggle) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundStyle(isFavorite ? .red : .gray)
                .symbolEffect(.bounce, value: isFavorite)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(accessibilityID)
    }
}

#Preview {
    HStack(spacing: 20) {
        FavoriteButton(accessibilityID: "fav_1", isFavorite: true, onToggle: {})
        FavoriteButton(accessibilityID: "fav_2", isFavorite: false, onToggle: {})
    }
    .padding()
}
