import Foundation
@testable import AppCore

final class MockAPIClient: APIClientProtocol, @unchecked Sendable {

    // MARK: - Properties

    var requestCallCount = 0
    var requestCalled = false
    var lastRequestedEndpoint: APIEndpoint?
    var stubbedError: Error?
    var stubbedData: Data?

    // MARK: - APIClientProtocol

    func request<T: Decodable & Sendable>(_ endpoint: APIEndpoint) async throws -> T {
        requestCalled = true
        requestCallCount += 1
        lastRequestedEndpoint = endpoint

        if let error = stubbedError {
            throw error
        }

        guard let data = stubbedData else {
            throw APIError.unknown
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
