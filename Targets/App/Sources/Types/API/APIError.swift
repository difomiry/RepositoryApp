import Foundation

struct APIError: Decodable {
	let message: String
}

extension APIError: LocalizedError {
	var errorDescription: String? {
		message
	}
}
