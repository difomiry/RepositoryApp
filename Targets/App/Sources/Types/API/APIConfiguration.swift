import Foundation

struct APIConfiguration {
	let baseComponents: URLComponents
	let baseHeaders: [String: String]
	let encoder: JSONEncoder
	let decoder: JSONDecoder
}
