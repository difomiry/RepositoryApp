import Foundation

final class APIConfigurationProviderImpl {}

extension APIConfigurationProviderImpl: APIConfigurationProvider {
	var configuration: APIConfiguration {
		APIConfiguration(
			baseComponents: URLComponents(
				scheme: "https",
				host: "api.github.com"
			),
			baseHeaders: [
				"Content-Type": "application/json"
			],
			encoder: JSONEncoder(),
			decoder: JSONDecoder()
		)
	}
}
