import Foundation

// MARK: - Protocol

public protocol APIClientProtocol: Sendable {
    func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint) async throws -> T
}

// MARK: - Implementation

public final class APIClient: APIClientProtocol, Sendable {

    // MARK: - Properties

    private let decoder: JSONDecoder
    private let session: URLSession

    // MARK: - Initializer

    public init(session: URLSession = .shared) {
        self.session = session
        let jsonDecoder = JSONDecoder()
        self.decoder = jsonDecoder
    }

    // MARK: - Public Methods

    public func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw APIError.unauthorized
        default:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error.localizedDescription)
        }
    }
}
