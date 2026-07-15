import SwiftUI

public struct LoadingView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let message: String

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        message: String = "Loading..."
    ) {
        self.accessibilityID = accessibilityID
        self.message = message
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 12) {
            ProgressView()
                .controlSize(.large)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier(accessibilityID)
    }
}

#Preview {
    LoadingView(accessibilityID: "preview_loading")
}
