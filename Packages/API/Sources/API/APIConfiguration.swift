import Foundation

public struct APIConfiguration {
	public let baseComponents: URLComponents
	public let baseHeaders: [String: String]
	public let encoder: JSONEncoder
	public let decoder: JSONDecoder

	public init(
		baseComponents: URLComponents,
		baseHeaders: [String: String],
		encoder: JSONEncoder,
		decoder: JSONDecoder
	) {
		self.baseComponents = baseComponents
		self.baseHeaders = baseHeaders
		self.encoder = encoder
		self.decoder = decoder
	}
}
