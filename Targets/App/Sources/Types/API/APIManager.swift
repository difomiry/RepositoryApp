protocol APIManager {
	func perform<T>(
		request: APIRequest<T>
	) async throws -> T where T: Decodable
}
