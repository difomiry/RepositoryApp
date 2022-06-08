import Foundation

final class UserServiceImpl {
	private let apiManager: APIManager

	init(apiManager: APIManager) {
		self.apiManager = apiManager
	}
}

extension UserServiceImpl: UserService {
	func current() async throws -> User {
		let request = APIRequest<User>(
			components: URLComponents(
				path: "/user"
			)
		)
		let response = try await apiManager.perform(request: request)
		return response
	}
}
