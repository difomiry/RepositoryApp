import Foundation

struct APIRequest<Response> where Response: Decodable {
	let method: String?
	let components: URLComponents
	let headers: [String: String]
	let isAuthenticationRequired: Bool

	init(
		method: String? = nil,
		components: URLComponents,
		headers: [String: String] = [:],
		isAuthenticationRequired: Bool = true
	) {
		self.method = method
		self.components = components
		self.headers = headers
		self.isAuthenticationRequired = isAuthenticationRequired
	}
}
