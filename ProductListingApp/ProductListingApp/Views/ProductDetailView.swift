import AppCore
import AppUI
import SwiftData
import SwiftUI

struct ProductDetailView: View {

    // MARK: - Properties

    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ProductDetailViewModel

    // MARK: - Initializer

    init(product: Product) {
        _viewModel = StateObject(wrappedValue: ProductDetailViewModel(product: product))
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                imageGallerySection
                headerSection
                priceSection
                infoSection
                reviewsSection
                tagsSection
            }
            .padding(.bottom, 24)
        }
        .navigationTitle(viewModel.product.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FavoriteButton(
                    accessibilityID: AccessibilityID.ProductDetail.buttonFavorite,
                    isFavorite: viewModel.isFavorite,
                    onToggle: { viewModel.toggleFavorite(modelContext: modelContext) }
                )
            }
        }
        .onAppear {
            viewModel.checkFavoriteStatus(modelContext: modelContext)
        }
        .accessibilityIdentifier(AccessibilityID.ProductDetail.viewContainer)
    }
}

// MARK: - Sections

private extension ProductDetailView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.product.title)
                .font(.title2)
                .fontWeight(.bold)
                .accessibilityIdentifier(AccessibilityID.ProductDetail.labelTitle)

            RatingView(
                accessibilityID: AccessibilityID.ProductDetail.ratingView,
                rating: viewModel.product.rating
            )

            Text(viewModel.product.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier(AccessibilityID.ProductDetail.labelDescription)
        }
        .padding(.horizontal)
    }

    var imageGallerySection: some View {
        ImageGalleryView(
            accessibilityID: AccessibilityID.ProductDetail.imageGallery,
            imageURLs: viewModel.product.imageURLs
        )
    }

    var infoSection: some View {
        VStack(spacing: 0) {
            if let brand = viewModel.product.brand {
                InfoRowView(
                    accessibilityID: AccessibilityID.ProductDetail.infoBrand,
                    icon: "tag",
                    title: "Brand",
                    value: brand
                )
                Divider().padding(.leading, 48)
            }

            InfoRowView(
                accessibilityID: AccessibilityID.ProductDetail.infoCategory,
                icon: "square.grid.2x2",
                title: "Category",
                value: viewModel.product.category.capitalized
            )
            Divider().padding(.leading, 48)

            InfoRowView(
                accessibilityID: AccessibilityID.ProductDetail.infoAvailability,
                icon: "checkmark.circle",
                title: "Availability",
                value: viewModel.product.availabilityStatus
            )
            Divider().padding(.leading, 48)

            InfoRowView(
                accessibilityID: AccessibilityID.ProductDetail.infoDimensions,
                icon: "ruler",
                title: "Dimensions",
                value: viewModel.dimensionsFormatted
            )
            Divider().padding(.leading, 48)

            InfoRowView(
                accessibilityID: AccessibilityID.ProductDetail.infoMinOrder,
                icon: "number",
                title: "Min. Order",
                value: "\(viewModel.product.minimumOrderQuantity) units"
            )
            Divider().padding(.leading, 48)

            InfoRowView(
                accessibilityID: AccessibilityID.ProductDetail.infoReturn,
                icon: "arrow.uturn.left",
                title: "Return Policy",
                value: viewModel.product.returnPolicy
            )
            Divider().padding(.leading, 48)

            InfoRowView(
                accessibilityID: AccessibilityID.ProductDetail.infoShipping,
                icon: "shippingbox",
                title: "Shipping",
                value: viewModel.product.shippingInformation
            )
            Divider().padding(.leading, 48)

            InfoRowView(
                accessibilityID: AccessibilityID.ProductDetail.infoSku,
                icon: "barcode",
                title: "SKU",
                value: viewModel.product.sku
            )
            Divider().padding(.leading, 48)

            InfoRowView(
                accessibilityID: AccessibilityID.ProductDetail.infoStock,
                icon: "archivebox",
                title: "Stock",
                value: "\(viewModel.product.stock) available"
            )
            Divider().padding(.leading, 48)

            InfoRowView(
                accessibilityID: AccessibilityID.ProductDetail.infoWarranty,
                icon: "shield",
                title: "Warranty",
                value: viewModel.product.warrantyInformation
            )
            Divider().padding(.leading, 48)

            InfoRowView(
                accessibilityID: AccessibilityID.ProductDetail.infoWeight,
                icon: "scalemass",
                title: "Weight",
                value: viewModel.weightFormatted
            )
        }
        .padding(.horizontal)
    }

    var priceSection: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(viewModel.discountedPriceFormatted)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            if viewModel.hasDiscount {
                Text(viewModel.originalPriceFormatted)
                    .font(.body)
                    .strikethrough()
                    .foregroundStyle(.secondary)

                Text("-\(Int(viewModel.product.discountPercentage))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red, in: Capsule())
            }
        }
        .padding(.horizontal)
        .accessibilityIdentifier(AccessibilityID.ProductDetail.labelPrice)
    }

    var reviewsSection: some View {
        Group {
            if viewModel.hasReviews {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reviews (\(viewModel.product.reviews.count))")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(Array(viewModel.product.reviews.enumerated()), id: \.element.id) { index, review in
                        ReviewCardView(
                            accessibilityID: AccessibilityID.ProductDetail.reviewCard(index),
                            comment: review.comment,
                            date: review.date,
                            rating: review.rating,
                            reviewerName: review.reviewerName
                        )
                        .padding(.horizontal)
                    }
                }
                .accessibilityIdentifier(AccessibilityID.ProductDetail.sectionReviews)
            }
        }
    }

    var tagsSection: some View {
        Group {
            if !viewModel.product.tags.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tags")
                        .font(.headline)

                    FlowLayout(spacing: 8) {
                        ForEach(viewModel.product.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1), in: Capsule())
                                .foregroundStyle(Color.blue)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Flow Layout

private struct FlowLayout: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }

        return (positions, CGSize(width: maxWidth, height: currentY + lineHeight))
    }
}
