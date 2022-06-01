protocol SearchService {
	func search(query: String, page: Int) async throws -> SearchResponse
	func recent() async throws -> [Repository]
}
