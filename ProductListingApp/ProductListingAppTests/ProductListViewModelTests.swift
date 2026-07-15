import XCTest
@testable import AppCore
@testable import ProductListingApp

@MainActor
final class ProductListViewModelTests: XCTestCase {

    // MARK: - Properties

    private var mockFavoriteService: MockFavoriteService!
    private var mockService: MockProductService!
    private var sut: ProductListViewModel!

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        mockFavoriteService = MockFavoriteService()
        mockService = MockProductService()
        sut = ProductListViewModel(
            favoriteService: mockFavoriteService,
            pageSize: 10,
            productService: mockService
        )
    }

    override func tearDown() {
        mockFavoriteService = nil
        mockService = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - FetchProducts Tests

    func test_fetchProducts_success_updatesProducts() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)

        // Act
        await sut.fetchProducts()

        // Assert
        XCTAssertTrue(sut.hasProducts)
        XCTAssertEqual(sut.filteredProducts.count, 2)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }

    func test_fetchProducts_success_updatesCategories() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)

        // Act
        await sut.fetchProducts()

        // Assert
        XCTAssertEqual(sut.allCategories, ["beauty", "electronics"])
    }

    func test_fetchProducts_success_setsHasMorePages() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)

        // Act
        await sut.fetchProducts()

        // Assert
        XCTAssertTrue(sut.hasMorePages)
    }

    func test_fetchProducts_singlePage_setsNoMorePages() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mockSinglePage)

        // Act
        await sut.fetchProducts()

        // Assert
        XCTAssertFalse(sut.hasMorePages)
    }

    func test_fetchProducts_networkError_setsErrorMessage() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .failure(APIError.networkError("No connection"))

        // Act
        await sut.fetchProducts()

        // Assert
        XCTAssertFalse(sut.hasProducts)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_fetchProducts_emptyResponse_hasNoProducts() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mockEmpty)

        // Act
        await sut.fetchProducts()

        // Assert
        XCTAssertFalse(sut.hasProducts)
        XCTAssertNil(sut.errorMessage)
    }

    func test_fetchProducts_callsServiceWithCorrectParams() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)

        // Act
        await sut.fetchProducts()

        // Assert
        XCTAssertTrue(mockService.fetchProductsCalled)
        XCTAssertEqual(mockService.lastFetchLimit, 10)
        XCTAssertEqual(mockService.lastFetchSkip, 0)
    }

    // MARK: - LoadMore Tests

    func test_loadMoreIfNeeded_lastProduct_loadsNextPage() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)
        await sut.fetchProducts()
        mockService.fetchProductsCallCount = 0

        let lastProduct = sut.filteredProducts.last!

        // Act
        await sut.loadMoreIfNeeded(currentProduct: lastProduct)

        // Assert
        XCTAssertTrue(mockService.fetchProductsCalled)
        XCTAssertEqual(mockService.lastFetchSkip, 2)
    }

    func test_loadMoreIfNeeded_notLastProduct_doesNotLoad() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)
        await sut.fetchProducts()
        mockService.fetchProductsCallCount = 0

        let firstProduct = sut.filteredProducts.first!

        // Act
        await sut.loadMoreIfNeeded(currentProduct: firstProduct)

        // Assert
        XCTAssertEqual(mockService.fetchProductsCallCount, 0)
    }

    func test_loadMoreIfNeeded_noMorePages_doesNotLoad() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mockSinglePage)
        await sut.fetchProducts()
        mockService.fetchProductsCallCount = 0

        let lastProduct = sut.filteredProducts.last!

        // Act
        await sut.loadMoreIfNeeded(currentProduct: lastProduct)

        // Assert
        XCTAssertEqual(mockService.fetchProductsCallCount, 0)
    }

    func test_loadMoreIfNeeded_error_showsToast() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)
        await sut.fetchProducts()
        mockService.stubbedFetchProductsResult = .failure(APIError.networkError("Failed"))

        let lastProduct = sut.filteredProducts.last!

        // Act
        await sut.loadMoreIfNeeded(currentProduct: lastProduct)

        // Assert
        XCTAssertTrue(sut.showToast)
        XCTAssertFalse(sut.toastMessage.isEmpty)
    }

    // MARK: - Filter Tests

    func test_filteredProducts_categoryFilter_filtersCorrectly() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)
        await sut.fetchProducts()

        // Act
        sut.filterState.toggleCategory("beauty")

        // Assert
        XCTAssertEqual(sut.filteredProducts.count, 1)
        XCTAssertEqual(sut.filteredProducts.first?.category, "beauty")
    }

    func test_filteredProducts_ratingFilter_filtersCorrectly() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)
        await sut.fetchProducts()

        // Act
        sut.filterState.toggleMinRating(4.0)

        // Assert
        XCTAssertEqual(sut.filteredProducts.count, 1)
        XCTAssertEqual(sut.filteredProducts.first?.id, 2)
    }

    func test_filteredProducts_sortByPriceLowToHigh_sortsCorrectly() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)
        await sut.fetchProducts()

        // Act
        sut.filterState.toggleSortOption("Price: Low to High")

        // Assert
        XCTAssertEqual(sut.filteredProducts.first?.price, 9.99)
        XCTAssertEqual(sut.filteredProducts.last?.price, 19.99)
    }

    func test_filteredProducts_sortByPriceHighToLow_sortsCorrectly() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)
        await sut.fetchProducts()

        // Act
        sut.filterState.toggleSortOption("Price: High to Low")

        // Assert
        XCTAssertEqual(sut.filteredProducts.first?.price, 19.99)
        XCTAssertEqual(sut.filteredProducts.last?.price, 9.99)
    }

    func test_filteredProducts_sortByRating_sortsCorrectly() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)
        await sut.fetchProducts()

        // Act
        sut.filterState.toggleSortOption("Rating: High to Low")

        // Assert
        XCTAssertEqual(sut.filteredProducts.first?.rating, 4.12)
    }

    func test_filteredProducts_sortByName_sortsCorrectly() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)
        await sut.fetchProducts()

        // Act
        sut.filterState.toggleSortOption("Name: A to Z")

        // Assert
        XCTAssertEqual(sut.filteredProducts.first?.title, "Essence Mascara Lash Princess")
        XCTAssertEqual(sut.filteredProducts.last?.title, "Eyeshadow Palette with Mirror")
    }

    func test_resetFilters_clearsAllFilters() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .success(.mock)
        await sut.fetchProducts()
        sut.filterState.toggleCategory("beauty")
        sut.filterState.toggleMinRating(3.0)
        sut.filterState.toggleSortOption("Price: Low to High")

        // Act
        sut.resetFilters()

        // Assert
        XCTAssertTrue(sut.filterState.selectedCategories.isEmpty)
        XCTAssertNil(sut.filterState.minRating)
        XCTAssertNil(sut.filterState.sortOption)
        XCTAssertFalse(sut.filterState.isActive)
    }

    // MARK: - Error & Toast Tests

    func test_clearError_removesErrorMessage() async {
        // Arrange
        mockService.stubbedFetchProductsResult = .failure(APIError.networkError("Error"))
        await sut.fetchProducts()

        // Act
        sut.clearError()

        // Assert
        XCTAssertNil(sut.errorMessage)
    }

    func test_dismissToast_hidesMessage() {
        // Arrange — toast state is set via internal showToastMessage

        // Act
        sut.dismissToast()

        // Assert
        XCTAssertFalse(sut.showToast)
        XCTAssertTrue(sut.toastMessage.isEmpty)
    }

    // MARK: - FilterState Tests

    func test_filterState_toggleCategory_addsAndRemoves() {
        // Arrange
        var state = FilterState()

        // Act
        state.toggleCategory("beauty")

        // Assert
        XCTAssertTrue(state.selectedCategories.contains("beauty"))

        // Act
        state.toggleCategory("beauty")

        // Assert
        XCTAssertFalse(state.selectedCategories.contains("beauty"))
    }

    func test_filterState_toggleMinRating_setsAndClears() {
        // Arrange
        var state = FilterState()

        // Act
        state.toggleMinRating(3.0)

        // Assert
        XCTAssertEqual(state.minRating, 3.0)

        // Act
        state.toggleMinRating(3.0)

        // Assert
        XCTAssertNil(state.minRating)
    }

    func test_filterState_toggleSortOption_setsAndClears() {
        // Arrange
        var state = FilterState()

        // Act
        state.toggleSortOption("Price: Low to High")

        // Assert
        XCTAssertEqual(state.sortOption, "Price: Low to High")

        // Act
        state.toggleSortOption("Price: Low to High")

        // Assert
        XCTAssertNil(state.sortOption)
    }

    func test_filterState_isActive_withCategory_returnsTrue() {
        // Arrange
        var state = FilterState()

        // Act
        state.toggleCategory("beauty")

        // Assert
        XCTAssertTrue(state.isActive)
    }

    func test_filterState_isActive_empty_returnsFalse() {
        // Arrange
        let state = FilterState()

        // Act & Assert
        XCTAssertFalse(state.isActive)
    }

    func test_filterState_reset_clearsAll() {
        // Arrange
        var state = FilterState()
        state.toggleCategory("beauty")
        state.toggleMinRating(3.0)
        state.toggleSortOption("Name: A to Z")

        // Act
        state.reset()

        // Assert
        XCTAssertTrue(state.selectedCategories.isEmpty)
        XCTAssertNil(state.minRating)
        XCTAssertNil(state.sortOption)
        XCTAssertFalse(state.isActive)
    }
}
