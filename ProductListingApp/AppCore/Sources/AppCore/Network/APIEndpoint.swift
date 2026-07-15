import Foundation

public enum APIEndpoint: Equatable, Sendable {
    case products(limit: Int, skip: Int)
    case searchProducts(query: String, limit: Int, skip: Int)

    // MARK: - Properties

    var baseURL: String { "https://dummyjson.com" }

    var method: HTTPMethod { .get }

    var path: String {
        switch self {
        case .products:
            return "/products"
        case .searchProducts:
            return "/products/search"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .products(let limit, let skip):
            return [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "skip", value: "\(skip)")
            ]
        case .searchProducts(let query, let limit, let skip):
            return [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "skip", value: "\(skip)")
            ]
        }
    }

    // MARK: - URL Construction

    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
