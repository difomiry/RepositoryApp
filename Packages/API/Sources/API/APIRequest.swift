import Foundation

public struct APIRequest<Response> where Response: Decodable {
	public let method: String?
	public let components: URLComponents
	public let headers: [String: String]
	public let isAuthenticationRequired: Bool

	public init(
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
