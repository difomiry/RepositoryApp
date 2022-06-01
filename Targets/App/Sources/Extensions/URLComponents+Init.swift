import Foundation

extension URLComponents {
	init(
		scheme: String? = nil,
		host: String? = nil,
		path: String? = nil,
		queryItems: [URLQueryItem]? = nil
	) {
		self.init()
		self.scheme = scheme
		self.host = host
		self.path = path ?? self.path
		self.queryItems = queryItems
	}
}
