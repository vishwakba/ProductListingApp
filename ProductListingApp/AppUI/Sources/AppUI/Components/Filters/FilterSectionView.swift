import SwiftUI

public struct FilterSectionView: View {

    // MARK: - Properties

    private let accessibilityID: String
    private let categories: [String]
    private let onCategoryTap: (String) -> Void
    private let onRatingTap: (Double) -> Void
    private let onSortTap: (String) -> Void
    private let selectedCategories: Set<String>
    private let selectedMinRating: Double?
    private let selectedSort: String?
    private let sortOptions: [String]

    // MARK: - Initializer

    public init(
        accessibilityID: String,
        categories: [String],
        onCategoryTap: @escaping (String) -> Void,
        onRatingTap: @escaping (Double) -> Void,
        onSortTap: @escaping (String) -> Void,
        selectedCategories: Set<String>,
        selectedMinRating: Double?,
        selectedSort: String?,
        sortOptions: [String]
    ) {
        self.accessibilityID = accessibilityID
        self.categories = categories
        self.onCategoryTap = onCategoryTap
        self.onRatingTap = onRatingTap
        self.onSortTap = onSortTap
        self.selectedCategories = selectedCategories
        self.selectedMinRating = selectedMinRating
        self.selectedSort = selectedSort
        self.sortOptions = sortOptions
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !categories.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Categories")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                FilterChipView(
                                    accessibilityID: "\(accessibilityID)_category_\(category)",
                                    isSelected: selectedCategories.contains(category),
                                    onTap: { onCategoryTap(category) },
                                    title: category.capitalized
                                )
                            }
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Minimum Rating")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach([1.0, 2.0, 3.0, 4.0], id: \.self) { rating in
                            FilterChipView(
                                accessibilityID: "\(accessibilityID)_rating_\(Int(rating))",
                                isSelected: selectedMinRating == rating,
                                onTap: { onRatingTap(rating) },
                                title: "\(Int(rating))+ ★"
                            )
                        }
                    }
                }
            }

            if !sortOptions.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sort By")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(sortOptions, id: \.self) { option in
                                FilterChipView(
                                    accessibilityID: "\(accessibilityID)_sort_\(option)",
                                    isSelected: selectedSort == option,
                                    onTap: { onSortTap(option) },
                                    title: option
                                )
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .accessibilityIdentifier(accessibilityID)
    }
}
