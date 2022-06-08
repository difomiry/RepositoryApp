import Foundation

final class APIResponseMapperImpl {
	private let configurationProvider: APIConfigurationProvider

	init(configurationProvider: APIConfigurationProvider) {
		self.configurationProvider = configurationProvider
	}
}

extension APIResponseMapperImpl: APIResponseMapper {
	func map<T>(
		data: Data,
		response: URLResponse
	) async throws -> T where T: Decodable {
		let configuration = configurationProvider.configuration
		guard 200 ... 299 ~= (response as? HTTPURLResponse)?.statusCode ?? -1 else {
			throw try configuration.decoder.decode(APIError.self, from: data)
		}
		return try configuration.decoder.decode(T.self, from: data)
	}
}
