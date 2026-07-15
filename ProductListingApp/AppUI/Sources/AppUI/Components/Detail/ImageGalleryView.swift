import Kingfisher
import SwiftUI

public struct ImageGalleryView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let imageURLs: [URL]

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        imageURLs: [URL]
    ) {
        self.accessibilityID = accessibilityID
        self.imageURLs = imageURLs
    }

    // MARK: - Body

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(imageURLs.enumerated()), id: \.offset) { index, url in
                    KFImage(url)
                        .placeholder {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.15))
                                .overlay {
                                    ProgressView()
                                }
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .accessibilityIdentifier("\(accessibilityID)_\(index)")
                }
            }
            .padding(.horizontal)
        }
        .accessibilityIdentifier(accessibilityID)
    }
}

#Preview {
    ImageGalleryView(
        accessibilityID: "preview_gallery",
        imageURLs: []
    )
}
