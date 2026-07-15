import SwiftUI

public enum ToastType: Sendable {
    case error
    case info
    case success

    var iconName: String {
        switch self {
        case .error: return "xmark.circle.fill"
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .error: return .red
        case .info: return .blue
        case .success: return .green
        }
    }
}

public struct ToastView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let message: String
    private let type: ToastType

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        message: String,
        type: ToastType
    ) {
        self.accessibilityID = accessibilityID
        self.message = message
        self.type = type
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: type.iconName)
                .foregroundStyle(type.tintColor)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
        .accessibilityIdentifier(accessibilityID)
    }
}

#Preview {
    VStack(spacing: 16) {
        ToastView(accessibilityID: "toast_1", message: "Product added to favorites!", type: .success)
        ToastView(accessibilityID: "toast_2", message: "Network error occurred", type: .error)
        ToastView(accessibilityID: "toast_3", message: "Loading more products...", type: .info)
    }
}
