import Foundation

public protocol HTTPClient {
	func data(for request: URLRequest) async throws -> (Data, URLResponse)
}
