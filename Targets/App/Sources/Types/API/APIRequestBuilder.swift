import Foundation

protocol APIRequestBuilder {
	func build<T>(
		for request: APIRequest<T>
	) async throws -> URLRequest where T: Decodable
}
