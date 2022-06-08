import API
import Foundation

final class SearchServiceImpl {
	private let apiManager: APIManager
	private let storageManager: StorageManager

	init(
		apiManager: APIManager,
		storageManager: StorageManager
	) {
		self.apiManager = apiManager
		self.storageManager = storageManager
	}
}

extension SearchServiceImpl: SearchService {
	func search(query: String, page: Int) async throws -> SearchResponse {
		let request = APIRequest<SearchResponse>(
			components: URLComponents(
				path: "/search/repositories",
				queryItems: [
					URLQueryItem(name: "q", value: query),
					URLQueryItem(name: "page", value: "\(page)")
				]
			)
		)
		let response = try await apiManager.perform(request: request)
		return response
	}

	func recent() async throws -> [Repository] {
		try await storageManager.fetch()
	}
}
