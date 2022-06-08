import Foundation

public final class APIManagerImpl {
	private let httpClient: HTTPClient
	private let requestBuilder: APIRequestBuilder
	private let responseMapper: APIResponseMapper

	public init(
		httpClient: HTTPClient,
		requestBuilder: APIRequestBuilder,
		responseMapper: APIResponseMapper
	) {
		self.httpClient = httpClient
		self.requestBuilder = requestBuilder
		self.responseMapper = responseMapper
	}
}

extension APIManagerImpl: APIManager {
	public func perform<T>(
		request: APIRequest<T>
	) async throws -> T where T: Decodable {
		let request = try await requestBuilder.build(for: request)
		let (data, response) = try await httpClient.data(for: request)
		return try await responseMapper.map(
			data: data,
			response: response
		)
	}
}
