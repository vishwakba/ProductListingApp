import XCTest
@testable import AppCore

final class ProductModelTests: XCTestCase {

    // MARK: - Decoding Tests

    func test_product_decoding_fromSampleJSON_succeeds() throws {
        // Arrange
        let data = sampleProductJSON

        // Act
        let response = try JSONDecoder().decode(ProductResponse.self, from: data)

        // Assert
        XCTAssertEqual(response.products.count, 2)
    }

    func test_product_decoding_allFieldsPopulated() throws {
        // Arrange
        let data = sampleProductJSON

        // Act
        let response = try JSONDecoder().decode(ProductResponse.self, from: data)
        let product = response.products[0]

        // Assert
        XCTAssertEqual(product.id, 1)
        XCTAssertEqual(product.title, "Essence Mascara Lash Princess")
        XCTAssertEqual(product.brand, "Essence")
        XCTAssertEqual(product.sku, "BEA-ESS-ESS-001")
        XCTAssertEqual(product.weight, 4)
        XCTAssertEqual(product.warrantyInformation, "1 week warranty")
        XCTAssertEqual(product.shippingInformation, "Ships in 3-5 business days")
        XCTAssertEqual(product.returnPolicy, "No return policy")
        XCTAssertEqual(product.minimumOrderQuantity, 48)
    }

    func test_product_decoding_metaFields() throws {
        // Arrange
        let data = sampleProductJSON

        // Act
        let response = try JSONDecoder().decode(ProductResponse.self, from: data)
        let meta = response.products[0].meta

        // Assert
        XCTAssertEqual(meta.barcode, "5784719087687")
        XCTAssertFalse(meta.createdAt.isEmpty)
        XCTAssertFalse(meta.updatedAt.isEmpty)
    }

    // MARK: - Computed Property Tests

    func test_discountedPrice_withDiscount_returnsCorrectValue() {
        // Arrange
        let product = Product.mock

        // Act
        let discountedPrice = product.discountedPrice

        // Assert
        let expected = 9.99 * (1 - 10.48 / 100)
        XCTAssertEqual(discountedPrice, expected, accuracy: 0.01)
    }

    func test_thumbnailURL_validURL_returnsURL() {
        // Arrange
        let product = Product.mock

        // Act
        let url = product.thumbnailURL

        // Assert
        XCTAssertNotNil(url)
    }

    func test_imageURLs_validURLs_returnsURLArray() {
        // Arrange
        let product = Product.mock

        // Act
        let urls = product.imageURLs

        // Assert
        XCTAssertEqual(urls.count, 1)
    }

    // MARK: - Review Tests

    func test_review_id_isUnique() {
        // Arrange
        let review = Review.mock

        // Act
        let id = review.id

        // Assert
        XCTAssertFalse(id.isEmpty)
        XCTAssertTrue(id.contains("eleanor.collins"))
    }

    // MARK: - Equatable Tests

    func test_product_equatable_sameId_areEqual() {
        // Arrange
        let product1 = Product.mock
        let product2 = Product.mock

        // Act & Assert
        XCTAssertEqual(product1, product2)
    }

    func test_product_equatable_differentId_areNotEqual() {
        // Arrange
        let product1 = Product.mock
        let product2 = Product.mockSecond

        // Act & Assert
        XCTAssertNotEqual(product1, product2)
    }

    // MARK: - Empty Response Tests

    func test_emptyResponse_decoding_succeeds() throws {
        // Arrange
        let data = sampleEmptyResponseJSON

        // Act
        let response = try JSONDecoder().decode(ProductResponse.self, from: data)

        // Assert
        XCTAssertTrue(response.products.isEmpty)
        XCTAssertEqual(response.total, 0)
    }
}
