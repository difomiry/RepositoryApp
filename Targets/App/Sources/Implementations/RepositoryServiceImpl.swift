import Foundation

final class RepositoryServiceImpl {
	private let apiManager: APIManager
	private let httpClient: HTTPClient
	private let storageManager: StorageManager

	init(
		apiManager: APIManager,
		httpClient: HTTPClient,
		storageManager: StorageManager
	) {
		self.apiManager = apiManager
		self.httpClient = httpClient
		self.storageManager = storageManager
	}
}

extension RepositoryServiceImpl: RepositoryService {
	func readme(owner: String, name: String) async throws -> String {
		let request = APIRequest<ReadmeResponse>(
			components: URLComponents(
				path: "/repos/\(owner)/\(name)/readme"
			)
		)
		let response = try await apiManager.perform(request: request)
		guard let url = URL(string: response.downloadURL)
		else {
			throw URLError(.badURL)
		}
		let (data, _) = try await httpClient.data(for: URLRequest(url: url))
		guard let string = String(data: data, encoding: .utf8)
		else {
			throw URLError(.badServerResponse)
		}
		return string
	}

	func save(repository: Repository) async throws {
		try await storageManager.save(repository)
	}
}

private struct ReadmeResponse: Decodable {
	let downloadURL: String

	enum CodingKeys: String, CodingKey {
		case downloadURL = "download_url"
	}
}
