import Foundation

public enum APIError: Error, Equatable, LocalizedError {
    case decodingError(String)
    case invalidResponse
    case invalidURL
    case networkError(String)
    case serverError(statusCode: Int)
    case unauthorized
    case unknown

    // MARK: - LocalizedError

    public var errorDescription: String? {
        switch self {
        case .decodingError(let message):
            return "Failed to decode response: \(message)"
        case .invalidResponse:
            return "Invalid server response"
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let message):
            return "Network error: \(message)"
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .unauthorized:
            return "Unauthorized access"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
