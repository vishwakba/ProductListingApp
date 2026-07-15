# ProductListingApp

A modular iOS product listing app built with SwiftUI, Swift Package Manager, and MVVM architecture. Fetches products from the [DummyJSON API](https://dummyjson.com/products) with pagination, real-time search, multi-criteria filtering, favorites persistence, and a polished detail view.

## Screenshots

| Product List | Search & Filter | Product Detail | Favorites |
|---|---|---|---|
| *List with pagination* | *Real-time search + filters* | *Image gallery + info* | *Heart toggle on cards* |

## Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | SwiftUI |
| Language | Swift 6 |
| Architecture | MVVM + Multi-Module (SPM) |
| Networking | URLSession + async/await |
| Image Loading | Kingfisher (KFImage) via SPM |
| Persistence | SwiftData (@Model) |
| Concurrency | Swift Concurrency (async/await, @MainActor) |
| Testing | XCTest, AAA pattern |
| Min Deployment | iOS 17 |

## Project Structure

```
ProductListingApp/
├── AppCore/                          # SPM Package — Data & Business Logic
│   └── Sources/AppCore/
│       ├── Models/Response/
│       │   ├── Product.swift         # Product, Dimensions, ProductMeta, Review
│       │   └── ProductResponse.swift # Paginated API response wrapper
│       ├── Network/
│       │   ├── APIClient.swift       # APIClientProtocol + URLSession implementation
│       │   ├── APIEndpoint.swift     # .products(limit:skip:), .searchProducts(query:limit:skip:)
│       │   ├── APIError.swift        # Domain error enum (decoding, network, server, etc.)
│       │   └── HTTPMethod.swift      # HTTP method enum
│       ├── Persistence/
│       │   └── FavoriteProduct.swift  # SwiftData @Model for favorites
│       └── Services/
│           ├── FavoriteService.swift          # SwiftData-based favorite toggle/query
│           ├── FavoriteServiceProtocol.swift  # Protocol for DI & testability
│           ├── ProductService.swift           # API client consumer
│           └── ProductServiceProtocol.swift   # Protocol for DI & testability
│
├── AppUI/                            # SPM Package — Reusable UI Components
│   └── Sources/AppUI/Components/
│       ├── Buttons/FavoriteButton.swift       # Heart toggle button
│       ├── Cards/ProductCardView.swift        # Product card with thumbnail, price, rating, favorite
│       ├── Common/
│       │   ├── EmptyStateView.swift           # "No results" placeholder
│       │   ├── ErrorView.swift                # Error state with retry
│       │   ├── LoadingView.swift              # Loading spinner
│       │   ├── SearchBarView.swift            # Search text field
│       │   └── ToastView.swift                # Transient notification
│       ├── Detail/
│       │   ├── ImageGalleryView.swift         # Horizontal scrollable image gallery
│       │   ├── InfoRowView.swift              # Icon + label + value row
│       │   ├── RatingView.swift               # Star rating display
│       │   └── ReviewCardView.swift           # User review card
│       └── Filters/
│           ├── FilterChipView.swift           # Selectable filter chip
│           └── FilterSectionView.swift        # Category/rating/sort filter panel
│
├── ProductListingApp/                # Main App Target
│   ├── Accessibility/
│   │   └── AccessibilityID.swift     # Cross-platform automation identifiers
│   ├── Models/
│   │   └── FilterState.swift         # Client-side filter state management
│   ├── ViewModels/
│   │   ├── ProductListViewModel.swift    # List pagination, search, filter, favorites
│   │   └── ProductDetailViewModel.swift  # Detail formatting, favorite status
│   └── Views/
│       ├── ProductListView.swift     # Main list screen with NavigationStack
│       └── ProductDetailView.swift   # Detail screen with gallery, info, reviews
│
├── ProductListingAppTests/           # Unit Tests
│   ├── Mocks/
│   │   ├── MockProductService.swift      # Stubbed product API responses
│   │   └── MockFavoriteService.swift     # Stubbed favorite operations
│   ├── ProductListViewModelTests.swift   # 25+ tests covering all ViewModel logic
│   └── ProductDetailViewModelTests.swift # Computed property & state tests
│
├── .claude/                          # AI Workflow Configuration
│   ├── rules/                        # Coding standards (5 rule files)
│   ├── skills/                       # Reusable implementation patterns (3 skills)
│   └── workflows/                    # End-to-end feature workflow
│
└── requirements/                     # Feature requirement specifications
    └── feature-products.txt
```

## Architecture

### Multi-Module Design

```
┌──────────────────────────────────────────┐
│               Main App                   │
│  ViewModels · Views · Composition Root   │
├────────────────┬─────────────────────────┤
│    AppUI       │       AppCore           │
│  UI Components │  Network · Models ·     │
│  (Kingfisher)  │  Services · Persistence │
└────────────────┴─────────────────────────┘
     AppUI ──✕──▶ AppCore  (no dependency)
     AppCore ──✕──▶ AppUI  (no dependency)
```

- **AppUI** — Stateless, reusable SwiftUI components. Receives data and action closures as parameters. Depends only on Kingfisher for image loading. Has zero knowledge of business logic.
- **AppCore** — Network layer, API models, services, and SwiftData persistence. Uses async/await exclusively. Exposes protocols for all services to enable dependency injection and mocking.
- **Main App** — Composes both modules. ViewModels bridge AppCore data to AppUI components. Contains navigation, app lifecycle, and the composition root where concrete implementations are wired.

### MVVM Pattern

| Layer | Location | Responsibility |
|---|---|---|
| **Model** | AppCore | API response structs, SwiftData entities, service protocols |
| **ViewModel** | Main App | @MainActor ObservableObject — state management, service orchestration, UI-ready data |
| **View** | Main App + AppUI | SwiftUI views observe ViewModels; AppUI components are pure render functions |

### Dependency Injection

All services are defined as protocols in AppCore and injected via initializers:

```swift
// Protocol in AppCore
public protocol FavoriteServiceProtocol: Sendable {
    @MainActor func isFavorite(productId: Int, modelContext: ModelContext) -> Bool
    @MainActor func toggleFavorite(productId: Int, title: String, modelContext: ModelContext) -> Bool
}

// ViewModel accepts protocol, not concrete type
init(favoriteService: FavoriteServiceProtocol, productService: ProductServiceProtocol) { ... }

// Composition root wires concrete implementations
ProductListView(favoriteService: FavoriteService(), productService: ProductService())
```

## Features

### 1. Product List with Pagination
- Fetches products from `GET /products?limit=10&skip=0`
- Infinite scroll — loads next page when reaching the last item
- Duplicate call prevention via `isFetching` guard
- Pull-to-refresh support

### 2. Real-Time Search
- Debounced search (400ms) using Combine
- Calls `GET /products/search?q=query&limit=10&skip=0`
- Search bar remains visible on "No Results" and error states for easy cancellation

### 3. Multi-Criteria Filtering (Client-Side)
- **Category** — filter by product category (extracted from loaded data)
- **Minimum Rating** — 1+, 2+, 3+, 4+ star thresholds
- **Sort** — Price Low to High, Price High to Low, Rating High to Low, Name A to Z
- Collapsible filter panel with "Clear All" option

### 4. Favorites with SwiftData
- `FavoriteProduct` @Model stored in AppCore with `@Attribute(.unique)` on productId
- `FavoriteService` handles toggle and query logic via `ModelContext`
- Heart button integrated directly inside `ProductCardView` using callback pattern
- Toast notifications for add/remove feedback
- Favorite state visible on both list and detail screens

### 5. Product Detail
- Horizontal scrollable image gallery (KFImage)
- Pricing with discount badge and strikethrough original price
- Star rating display
- 11 info rows: brand, category, availability, dimensions, min order, return policy, shipping, SKU, stock, warranty, weight
- User reviews section with reviewer name, date, rating, and comment
- Tags displayed in a flow layout

### 6. Error Handling
- `ErrorView` with retry button for network failures
- `ToastView` for transient notifications (favorites, load-more failures)
- `EmptyStateView` for no-results and empty-data states
- Domain-specific `APIError` enum with `LocalizedError` conformance

### 7. UI/UX Polish
- Product cards with thumbnail, title, rating stars, price with discount badge, and favorite heart
- Full card tap detection via `contentShape(Rectangle())`
- `symbolEffect(.bounce)` animation on favorite toggle
- Smooth filter expand/collapse animation
- Loading spinner during initial fetch and pagination

## Accessibility

Cross-platform accessibility identifiers follow the `<screen>_<component>_<element>` convention for UI automation:

```swift
// Centralized enum — no inline string identifiers
AccessibilityID.ProductList.cellProduct(0)    // "product_list_cell_product_0"
AccessibilityID.ProductDetail.buttonFavorite  // "product_detail_button_favorite"
AccessibilityID.Common.viewLoading            // "common_view_loading"
```

Every interactive element and every element used in automation assertions has an identifier. AppUI components accept `accessibilityIdentifier` as a parameter so the caller assigns the correct ID.

## Testing

### Strategy
- **AAA Pattern** (Arrange-Act-Assert) for all tests
- **Naming**: `test_<method>_<condition>_<expectedResult>()`
- **100% coverage target** for all public methods and branches

### Test Suites

| Suite | Count | Covers |
|---|---|---|
| AppCore (APIEndpoint, APIError, ProductModel, ProductService) | 40 | Network layer, model decoding, error mapping |
| ProductListViewModelTests | 25+ | Fetch, pagination, filtering, sorting, error, toast, FilterState |
| ProductDetailViewModelTests | 12+ | Computed properties, formatting, availability color, initial state |

### Mocking

```swift
// Mock services conform to the same protocols as real implementations
class MockProductService: ProductServiceProtocol { ... }
class MockFavoriteService: FavoriteServiceProtocol { ... }
```

Mocks track call counts, capture parameters, and return configurable stubbed results.

### Running Tests

```bash
# AppCore module tests
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  xcodebuild test -scheme AppCore \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

# Main app ViewModel tests
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  xcodebuild test -project ProductListingApp.xcodeproj \
  -scheme ProductListingApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -only-testing:ProductListingAppTests
```

## How to Build & Run

1. Open `ProductListingApp/ProductListingApp.xcodeproj` in Xcode 26+
2. SPM packages (AppCore, AppUI, Kingfisher) resolve automatically
3. Select an iOS 17+ simulator (e.g., iPhone 17 Pro)
4. Build and run (Cmd+R)

## AI Documentation

### Scope of Usage

AI (Claude Code via CLI) was used throughout the development process across these areas:

| Area | What AI Generated | What I Reviewed/Modified |
|---|---|---|
| **Project scaffolding** | `.claude/rules/`, `.claude/skills/`, `.claude/workflows/`, CLAUDE.md, directory structure | Verified rules match team conventions, adjusted architecture constraints |
| **AppCore network layer** | APIClient, APIEndpoint, APIError, HTTPMethod, ProductService, all model structs | Validated URL construction, error mapping, Codable conformance against DummyJSON docs |
| **AppUI components** | All 13 SwiftUI components (cards, buttons, filters, detail views) | Tested visual output in simulator, iterated on layout/spacing, fixed tap detection and duplicate chevron issues |
| **ViewModels** | ProductListViewModel (pagination, search debounce, filtering), ProductDetailViewModel | Verified state transitions, confirmed debounce timing, validated filter logic edge cases |
| **SwiftData persistence** | FavoriteProduct @Model, FavoriteService, FavoriteServiceProtocol | Confirmed @Attribute(.unique) constraint, tested toggle idempotency |
| **Unit tests** | 40 AppCore tests, 37+ ViewModel tests, all mock classes | Reviewed assertions match actual behavior, verified edge cases covered |
| **Bug fixes** | 6 UI/architecture fixes (search bar visibility, duplicate arrows, tap detection, callback pattern, favorites migration to AppCore) | Identified all 6 bugs through manual testing, directed AI on specific fixes |
| **Xcode project config** | pbxproj modifications for local SPM package references | Verified build succeeds, resolved Swift 6 / Xcode 26 compatibility issues |

### Prompt Examples

**Example 1 — Initial Feature Implementation (Complex, Multi-Step)**

```
Read the requirement file at requirements/feature-products.txt.
Use the feature-integration workflow from .claude/workflows/feature-integration.md
with the rules from .claude/rules/ and skills from .claude/skills/ to implement it.
```

This single prompt triggered an 8-step structured workflow that:
1. Parsed the DummyJSON API spec from the requirements file
2. Built the entire AppCore network layer (endpoint enum, API client, models, service, mocks, 40 tests)
3. Created ViewModels with pagination, search debounce, and filtering
4. Generated 13 AppUI components with Kingfisher image loading
5. Composed the full ProductListView and ProductDetailView screens
6. Added cross-platform accessibility identifiers
7. Ran the Definition of Done checklist

The workflow-based approach ensured consistent architecture across all generated code.

**Example 2 — Targeted Bug Fix Batch (Directed Iteration)**

```
Implement these changes:
1. On "No results found", not able to use search flow or cancel the search flow. Not even seeing search bar.
2. I see two right arrows on product list item, one on product view ending and other right side of favorite button.
3. Move favorite button inside the product card view.
4. Clicking on entire product card view is not detecting. Only text or image is detecting the click.
5. Use callback for favoriting handshake between AppUI and App.
6. Move Favoriting SwiftData logic to AppCore.
```

This prompt addressed 6 issues identified during manual testing. The AI:
- Restructured ProductListView to show the search bar outside the List on empty/error states
- Removed the duplicate chevron from ProductCardView (NavigationLink already provides one)
- Moved FavoriteButton inside ProductCardView with `isFavorite: Bool` + `onFavoriteTap: () -> Void` callback parameters
- Added `contentShape(Rectangle())` for full-area tap detection
- Created FavoriteProduct, FavoriteServiceProtocol, and FavoriteService in AppCore
- Updated both ViewModels to accept FavoriteServiceProtocol via constructor injection
- Created MockFavoriteService and updated all test files

### Verification Process

1. **Compilation** — Every change was verified with `xcodebuild build` on the iPhone 17 Pro simulator before moving to the next step. Build failures (e.g., missing `import Combine` due to Swift 6 member import visibility, `.accentColor` deprecation in iOS 26 SDK) were caught and fixed immediately.

2. **Unit Tests** — 40 AppCore tests run and pass via `swift test`. ViewModel tests follow the AAA pattern with mock service injection. All public methods, error paths, and filter combinations are covered.

3. **Manual Testing** — The app was launched in the iOS simulator to verify:
   - Product list loads and paginates correctly
   - Search bar works on all states (results, no results, error)
   - Filters apply and clear properly
   - Product cards respond to taps across the full area
   - Favorite toggle works on both list and detail screens
   - Navigation transitions are smooth

4. **Architecture Review** — Verified the module dependency graph: AppUI has no imports from AppCore, AppCore has no imports from AppUI. SwiftData persistence logic lives in AppCore behind a protocol, keeping the Main App thin.

5. **Security** — No force unwrapping (`!`) in production code. No hardcoded API keys. URLSession used directly (no third-party HTTP libraries). All user input flows through the DummyJSON search API without local SQL or injection risk.

### Reflection

AI significantly accelerated the development timeline — what would typically take 20+ hours of boilerplate coding was completed in a fraction of the time. The structured workflow approach (rules + skills + workflows) was the key multiplier: by defining architecture rules upfront, every generated file followed consistent patterns (protocol-based DI, AAA tests, accessibility identifiers, MARK groupings).

The most valuable AI contributions were in areas with high boilerplate-to-logic ratios: model structs, mock classes, test cases, and the 13 AppUI components. These are areas where the patterns are well-established but tedious to write manually.

Where human judgment remained essential:
- **Bug identification** — All 6 UI bugs were found through manual simulator testing. AI generated the initial code, but visual issues like duplicate chevrons, non-responsive tap areas, and missing search bars required human eyes on the running app.
- **Architecture decisions** — The decision to move SwiftData favorites from the Main App to AppCore was a design judgment based on understanding the module boundary contract. AI implemented it, but the decision and rationale were mine.
- **SDK compatibility** — Xcode 26 and Swift 6 introduced breaking changes (`.accentColor` removal, explicit `import Combine` requirement, `MainActor` isolation) that required understanding the migration context, not just pattern matching.

The final architecture is cleaner than what I would have produced under the 48-hour time pressure without AI — the consistent protocol-based DI, comprehensive test coverage, and clean module boundaries benefit from AI's ability to apply patterns uniformly across many files simultaneously.
