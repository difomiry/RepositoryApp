protocol RepositoryService {
	func readme(owner: String, name: String) async throws -> String
	func save(repository: Repository) async throws
	func clear() async throws
}
