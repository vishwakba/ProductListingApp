import SwiftUI

public struct InfoRowView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let icon: String
    private let title: String
    private let value: String

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        icon: String,
        title: String,
        value: String
    ) {
        self.accessibilityID = accessibilityID
        self.icon = icon
        self.title = title
        self.value = value
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(Color.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline)
            }

            Spacer()
        }
        .accessibilityIdentifier(accessibilityID)
    }
}

#Preview {
    VStack {
        InfoRowView(accessibilityID: "preview_info_1", icon: "shippingbox", title: "Shipping", value: "Ships in 3-5 days")
        InfoRowView(accessibilityID: "preview_info_2", icon: "shield", title: "Warranty", value: "1 year warranty")
    }
    .padding()
}
