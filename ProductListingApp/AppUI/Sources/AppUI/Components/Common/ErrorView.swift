import SwiftUI

public struct ErrorView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let message: String
    private let onRetry: () -> Void

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        message: String,
        onRetry: @escaping () -> Void
    ) {
        self.accessibilityID = accessibilityID
        self.message = message
        self.onRetry = onRetry
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.orange)

            Text("Something went wrong")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: onRetry) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityIdentifier(accessibilityID)
    }
}

#Preview {
    ErrorView(
        accessibilityID: "preview_error",
        message: "Failed to load products. Please check your connection.",
        onRetry: {}
    )
}
