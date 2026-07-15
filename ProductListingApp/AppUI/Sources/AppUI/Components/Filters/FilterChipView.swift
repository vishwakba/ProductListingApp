import SwiftUI

public struct FilterChipView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let isSelected: Bool
    private let onTap: () -> Void
    private let title: String

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        isSelected: Bool,
        onTap: @escaping () -> Void,
        title: String
    ) {
        self.accessibilityID = accessibilityID
        self.isSelected = isSelected
        self.onTap = onTap
        self.title = title
    }

    // MARK: - Body

    public var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    isSelected ? Color.blue : Color(.systemGray5),
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(accessibilityID)
    }
}

#Preview {
    HStack {
        FilterChipView(accessibilityID: "chip_1", isSelected: true, onTap: {}, title: "Beauty")
        FilterChipView(accessibilityID: "chip_2", isSelected: false, onTap: {}, title: "Electronics")
    }
    .padding()
}
