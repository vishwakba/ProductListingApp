import Foundation

struct FilterState: Equatable {

    // MARK: - Properties

    var minRating: Double?
    var selectedCategories: Set<String> = []
    var sortOption: String?

    // MARK: - Computed Properties

    var isActive: Bool {
        !selectedCategories.isEmpty || minRating != nil || sortOption != nil
    }

    // MARK: - Sort Options

    static let sortOptions = [
        "Price: Low to High",
        "Price: High to Low",
        "Rating: High to Low",
        "Name: A to Z"
    ]

    // MARK: - Methods

    mutating func reset() {
        minRating = nil
        selectedCategories = []
        sortOption = nil
    }

    mutating func toggleCategory(_ category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }

    mutating func toggleMinRating(_ rating: Double) {
        if minRating == rating {
            minRating = nil
        } else {
            minRating = rating
        }
    }

    mutating func toggleSortOption(_ option: String) {
        if sortOption == option {
            sortOption = nil
        } else {
            sortOption = option
        }
    }
}
