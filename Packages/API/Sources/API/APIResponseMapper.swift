import Foundation

public protocol APIResponseMapper {
	func map<T>(
		data: Data,
		response: URLResponse
	) async throws -> T where T: Decodable
}
