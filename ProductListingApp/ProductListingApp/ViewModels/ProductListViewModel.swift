import AppCore
import Combine
import Foundation
import SwiftData

@MainActor
final class ProductListViewModel: ObservableObject {

    // MARK: - Properties

    @Published private(set) var allCategories: [String] = []
    @Published private(set) var errorMessage: String?
    @Published var filterState = FilterState()
    @Published private(set) var hasMorePages = true
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published var searchText = ""
    @Published private(set) var showToast = false
    @Published private(set) var toastMessage = ""

    private var allProducts: [Product] = []
    private var currentSkip = 0
    private let favoriteService: FavoriteServiceProtocol
    private var isFetching = false
    private let pageSize: Int
    private let productService: ProductServiceProtocol
    private var searchCancellable: AnyCancellable?
    private var totalProducts = 0

    // MARK: - Initializer

    init(
        favoriteService: FavoriteServiceProtocol = FavoriteService(),
        pageSize: Int = 10,
        productService: ProductServiceProtocol
    ) {
        self.favoriteService = favoriteService
        self.pageSize = pageSize
        self.productService = productService
        setupSearchDebounce()
    }

    // MARK: - Computed Properties

    var filteredProducts: [Product] {
        var result = allProducts

        if !filterState.selectedCategories.isEmpty {
            result = result.filter { filterState.selectedCategories.contains($0.category) }
        }

        if let minRating = filterState.minRating {
            result = result.filter { $0.rating >= minRating }
        }

        if let sortOption = filterState.sortOption {
            result = applySorting(result, by: sortOption)
        }

        return result
    }

    var hasProducts: Bool {
        !filteredProducts.isEmpty
    }

    // MARK: - Public Methods

    func clearError() {
        errorMessage = nil
    }

    func dismissToast() {
        showToast = false
        toastMessage = ""
    }

    func fetchProducts(showFullScreenLoading: Bool = true) async {
        guard !isFetching else { return }
        isFetching = true
        errorMessage = nil
        currentSkip = 0

        if showFullScreenLoading {
            isLoading = true
            allProducts = []
        }

        do {
            let response: ProductResponse
            if searchText.isEmpty {
                response = try await productService.fetchProducts(limit: pageSize, skip: 0)
            } else {
                response = try await productService.searchProducts(query: searchText, limit: pageSize, skip: 0)
            }

            allProducts = response.products
            totalProducts = response.total
            currentSkip = response.products.count
            hasMorePages = currentSkip < totalProducts
            updateCategories()
        } catch {
            errorMessage = (error as? APIError)?.errorDescription ?? error.localizedDescription
        }

        isLoading = false
        isFetching = false
    }

    func isFavorite(productId: Int, modelContext: ModelContext) -> Bool {
        favoriteService.isFavorite(productId: productId, modelContext: modelContext)
    }

    func loadMoreIfNeeded(currentProduct: Product) async {
        guard let lastProduct = allProducts.last,
              lastProduct.id == currentProduct.id,
              hasMorePages,
              !isFetching else { return }

        isFetching = true
        isLoadingMore = true

        do {
            let response: ProductResponse
            if searchText.isEmpty {
                response = try await productService.fetchProducts(limit: pageSize, skip: currentSkip)
            } else {
                response = try await productService.searchProducts(query: searchText, limit: pageSize, skip: currentSkip)
            }

            allProducts.append(contentsOf: response.products)
            totalProducts = response.total
            currentSkip += response.products.count
            hasMorePages = currentSkip < totalProducts
            updateCategories()
        } catch {
            showToastMessage("Failed to load more products")
        }

        isLoadingMore = false
        isFetching = false
    }

    func resetFilters() {
        filterState.reset()
    }

    func toggleFavorite(product: Product, modelContext: ModelContext) {
        let isFav = favoriteService.toggleFavorite(
            productId: product.id,
            title: product.title,
            modelContext: modelContext
        )
        showToastMessage(isFav ? "Added to favorites" : "Removed from favorites")
    }
}

// MARK: - Private Methods

private extension ProductListViewModel {
    func applySorting(_ products: [Product], by option: String) -> [Product] {
        switch option {
        case "Name: A to Z":
            return products.sorted { $0.title < $1.title }
        case "Price: High to Low":
            return products.sorted { $0.price > $1.price }
        case "Price: Low to High":
            return products.sorted { $0.price < $1.price }
        case "Rating: High to Low":
            return products.sorted { $0.rating > $1.rating }
        default:
            return products
        }
    }

    func setupSearchDebounce() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.fetchProducts(showFullScreenLoading: false)
                }
            }
    }

    func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
    }

    func updateCategories() {
        let categories = Set(allProducts.map(\.category))
        allCategories = categories.sorted()
    }
}
