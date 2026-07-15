import SwiftUI

public struct EmptyStateView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let message: String
    private let systemImage: String
    private let title: String

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        message: String,
        systemImage: String = "tray",
        title: String
    ) {
        self.accessibilityID = accessibilityID
        self.message = message
        self.systemImage = systemImage
        self.title = title
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier(accessibilityID)
    }
}

#Preview {
    EmptyStateView(
        accessibilityID: "preview_empty",
        message: "Try adjusting your search or filters.",
        title: "No Products Found"
    )
}
