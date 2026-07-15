import XCTest
@testable import AppCore
@testable import ProductListingApp

@MainActor
final class ProductDetailViewModelTests: XCTestCase {

    // MARK: - Properties

    private var mockFavoriteService: MockFavoriteService!
    private var sut: ProductDetailViewModel!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        mockFavoriteService = MockFavoriteService()
        sut = ProductDetailViewModel(favoriteService: mockFavoriteService, product: .mock)
    }

    override func tearDown() {
        mockFavoriteService = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Product Property Tests

    func test_product_returnsInjectedProduct() {
        // Arrange & Act (via setUp)

        // Assert
        XCTAssertEqual(sut.product.id, 1)
        XCTAssertEqual(sut.product.title, "Essence Mascara Lash Princess")
    }

    // MARK: - Computed Property Tests

    func test_discountedPriceFormatted_returnsFormattedString() {
        // Arrange (via setUp)

        // Act
        let formatted = sut.discountedPriceFormatted

        // Assert
        XCTAssertTrue(formatted.hasPrefix("$"))
        XCTAssertTrue(formatted.contains("."))
    }

    func test_originalPriceFormatted_returnsFormattedString() {
        // Arrange (via setUp)

        // Act
        let formatted = sut.originalPriceFormatted

        // Assert
        XCTAssertEqual(formatted, "$9.99")
    }

    func test_hasDiscount_withDiscount_returnsTrue() {
        // Arrange (via setUp — product has 10.48% discount)

        // Act & Assert
        XCTAssertTrue(sut.hasDiscount)
    }

    func test_hasDiscount_noDiscount_returnsFalse() {
        // Arrange
        let product = Product(
            availabilityStatus: "In Stock",
            brand: "Test",
            category: "test",
            description: "Test",
            dimensions: Dimensions(depth: 1, height: 1, width: 1),
            discountPercentage: 0,
            id: 99,
            images: [],
            meta: ProductMeta(barcode: "", createdAt: "", qrCode: "", updatedAt: ""),
            minimumOrderQuantity: 1,
            price: 10.0,
            rating: 4.0,
            returnPolicy: "None",
            reviews: [],
            shippingInformation: "Ships",
            sku: "TEST",
            stock: 10,
            tags: [],
            thumbnail: "",
            title: "Test Product",
            warrantyInformation: "None",
            weight: 1
        )
        let vm = ProductDetailViewModel(favoriteService: mockFavoriteService, product: product)

        // Act & Assert
        XCTAssertFalse(vm.hasDiscount)
    }

    func test_hasReviews_withReviews_returnsTrue() {
        // Arrange (via setUp — product has 1 review)

        // Act & Assert
        XCTAssertTrue(sut.hasReviews)
    }

    func test_hasReviews_noReviews_returnsFalse() {
        // Arrange
        let vm = ProductDetailViewModel(favoriteService: mockFavoriteService, product: .mockSecond)

        // Act & Assert
        XCTAssertFalse(vm.hasReviews)
    }

    func test_dimensionsFormatted_returnsCorrectFormat() {
        // Arrange (via setUp)

        // Act
        let formatted = sut.dimensionsFormatted

        // Assert
        XCTAssertTrue(formatted.contains("×"))
        XCTAssertTrue(formatted.contains("cm"))
    }

    func test_weightFormatted_returnsCorrectFormat() {
        // Arrange (via setUp)

        // Act
        let formatted = sut.weightFormatted

        // Assert
        XCTAssertEqual(formatted, "4 g")
    }

    func test_availabilityColor_inStock_returnsGreen() {
        // Arrange (via setUp — status is "In Stock")

        // Act & Assert
        XCTAssertEqual(sut.availabilityColor, "green")
    }

    func test_availabilityColor_lowStock_returnsOrange() {
        // Arrange
        let vm = ProductDetailViewModel(favoriteService: mockFavoriteService, product: .mockSecond)

        // Act & Assert
        XCTAssertEqual(vm.availabilityColor, "orange")
    }

    func test_availabilityColor_outOfStock_returnsRed() {
        // Arrange
        let product = Product(
            availabilityStatus: "Out of Stock",
            brand: nil,
            category: "test",
            description: "Test",
            dimensions: Dimensions(depth: 1, height: 1, width: 1),
            discountPercentage: 0,
            id: 99,
            images: [],
            meta: ProductMeta(barcode: "", createdAt: "", qrCode: "", updatedAt: ""),
            minimumOrderQuantity: 1,
            price: 10.0,
            rating: 4.0,
            returnPolicy: "None",
            reviews: [],
            shippingInformation: "Ships",
            sku: "TEST",
            stock: 0,
            tags: [],
            thumbnail: "",
            title: "Test",
            warrantyInformation: "None",
            weight: 1
        )
        let vm = ProductDetailViewModel(favoriteService: mockFavoriteService, product: product)

        // Act & Assert
        XCTAssertEqual(vm.availabilityColor, "red")
    }

    // MARK: - Favorite Tests

    func test_isFavorite_initialValue_isFalse() {
        // Arrange (via setUp)

        // Act & Assert
        XCTAssertFalse(sut.isFavorite)
    }
}
