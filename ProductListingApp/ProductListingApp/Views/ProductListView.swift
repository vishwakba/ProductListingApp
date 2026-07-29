import AppCore
import AppUI
import SwiftData
import SwiftUI

struct ProductListView: View {

    // MARK: - Properties

    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ProductListViewModel
    @State private var isFilterExpanded = false
    @State private var searchQuery = ""

    // MARK: - Initializer

    init(favoriteService: FavoriteServiceProtocol, productService: ProductServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ProductListViewModel(
            favoriteService: favoriteService,
            productService: productService
        ))
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                contentView
                toastOverlay
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    filterButton
                }
            }
        }
        .accessibilityIdentifier(AccessibilityID.ProductList.viewContainer)
        .onChange(of: searchQuery) { _, newValue in
            viewModel.searchText = newValue
        }
        .onChange(of: viewModel.searchText) { _, newValue in
            if searchQuery != newValue {
                searchQuery = newValue
            }
        }
    }
}

// MARK: - Subviews

private extension ProductListView {
    @ViewBuilder
    var contentView: some View {
        if viewModel.isLoading {
            LoadingView(
                accessibilityID: AccessibilityID.Common.viewLoading,
                message: "Loading products..."
            )
        } else if !viewModel.hasProducts && viewModel.searchText.isEmpty && viewModel.errorMessage == nil {
            EmptyStateView(
                accessibilityID: AccessibilityID.Common.viewEmpty,
                message: "No products available at the moment.",
                title: "No Products"
            )
        } else {
            productListView
        }
    }

    var filterButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                isFilterExpanded.toggle()
            }
        } label: {
            Image(systemName: viewModel.filterState.isActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                .symbolRenderingMode(.hierarchical)
        }
        .accessibilityIdentifier(AccessibilityID.ProductList.buttonFilter)
    }

    var productListView: some View {
        List {
            Section {
                SearchBarView(
                    accessibilityID: AccessibilityID.ProductList.textfieldSearch,
                    placeholder: "Search products...",
                    text: $searchQuery
                )
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }

            if isFilterExpanded {
                Section {
                    FilterSectionView(
                        accessibilityID: AccessibilityID.ProductList.viewFilter,
                        categories: viewModel.allCategories,
                        onCategoryTap: { viewModel.filterState.toggleCategory($0) },
                        onRatingTap: { viewModel.filterState.toggleMinRating($0) },
                        onSortTap: { viewModel.filterState.toggleSortOption($0) },
                        selectedCategories: viewModel.filterState.selectedCategories,
                        selectedMinRating: viewModel.filterState.minRating,
                        selectedSort: viewModel.filterState.sortOption,
                        sortOptions: FilterState.sortOptions
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))

                    if viewModel.filterState.isActive {
                        Button("Clear All Filters") {
                            viewModel.resetFilters()
                        }
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                    }
                }
            }

            if let errorMessage = viewModel.errorMessage {
                Section {
                    ErrorView(
                        accessibilityID: AccessibilityID.Common.viewError,
                        message: errorMessage,
                        onRetry: { Task { await viewModel.fetchProducts() } }
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 40, leading: 16, bottom: 40, trailing: 16))
                }
            } else if viewModel.hasProducts {
                Section {
                    ForEach(Array(viewModel.filteredProducts.enumerated()), id: \.element.id) { index, product in
                        NavigationLink(value: product) {
                            ProductCardView(
                                accessibilityID: AccessibilityID.ProductList.cellProduct(index),
                                discountPercentage: product.discountPercentage,
                                isFavorite: viewModel.isFavorite(productId: product.id, modelContext: modelContext),
                                onFavoriteTap: {
                                    viewModel.toggleFavorite(product: product, modelContext: modelContext)
                                },
                                price: product.price,
                                rating: product.rating,
                                thumbnailURL: product.thumbnailURL,
                                title: product.title
                            )
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .task {
                            await viewModel.loadMoreIfNeeded(currentProduct: product)
                        }
                    }
                }
            } else {
                Section {
                    EmptyStateView(
                        accessibilityID: AccessibilityID.Common.viewEmpty,
                        message: "Try adjusting your search or filters.",
                        systemImage: "magnifyingglass",
                        title: "No Results Found"
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 40, leading: 16, bottom: 40, trailing: 16))
                }
            }

            if viewModel.isLoadingMore {
                Section {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding()
                        Spacer()
                    }
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.fetchProducts()
        }
        .navigationDestination(for: Product.self) { product in
            ProductDetailView(product: product)
        }
        .accessibilityIdentifier(AccessibilityID.ProductList.listProducts)
    }

    @ViewBuilder
    var toastOverlay: some View {
        if viewModel.showToast {
            VStack {
                Spacer()
                ToastView(
                    accessibilityID: AccessibilityID.Common.viewToast,
                    message: viewModel.toastMessage,
                    type: .success
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { viewModel.dismissToast() }
                    }
                }
                .padding(.bottom, 20)
            }
            .animation(.easeInOut, value: viewModel.showToast)
        }
    }
}
