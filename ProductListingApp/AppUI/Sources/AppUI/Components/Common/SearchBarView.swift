import SwiftUI

public struct SearchBarView: View {

    // MARK: - Properties

    private let accessibilityID: String
    @Binding private var text: String
    private let placeholder: String

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        placeholder: String = "Search...",
        text: Binding<String>
    ) {
        self.accessibilityID = accessibilityID
        self.placeholder = placeholder
        self._text = text
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .autocorrectionDisabled()

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
        .accessibilityIdentifier(accessibilityID)
    }
}

#Preview {
    @Previewable @State var text = ""
    SearchBarView(
        accessibilityID: "preview_search",
        text: $text
    )
    .padding()
}
