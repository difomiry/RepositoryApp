import Foundation

final class APIRequestBuilderImpl {
	private let credentialsManager: CredentialsManager
	private let configurationProvider: APIConfigurationProvider

	init(
		credentialsManager: CredentialsManager,
		configurationProvider: APIConfigurationProvider
	) {
		self.credentialsManager = credentialsManager
		self.configurationProvider = configurationProvider
	}
}

extension APIRequestBuilderImpl: APIRequestBuilder {
	func build<T>(
		for request: APIRequest<T>
	) async throws -> URLRequest where T: Decodable {
		let configuration = configurationProvider.configuration
		var components = configuration.baseComponents
		components.host = request.components.host ?? components.host
		components.path = request.components.path
		components.queryItems = request.components.queryItems ?? components.queryItems
		guard let url = components.url else {
			throw URLError(.badURL)
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = request.method
		urlRequest.allHTTPHeaderFields = configuration.baseHeaders.merging(request.headers) { $1 }
		if request.isAuthenticationRequired, let token = credentialsManager.credentials.token {
			urlRequest.allHTTPHeaderFields?["Authorization"] = "token \(token)"
		}
		return urlRequest
	}
}
