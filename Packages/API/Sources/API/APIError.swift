import Foundation

public struct APIError: Decodable {
	public let message: String

	public init(message: String) {
		self.message = message
	}
}

extension APIError: LocalizedError {
	public var errorDescription: String? {
		message
	}
}
