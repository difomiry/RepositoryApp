protocol AppCoordinator {
	func start()
}

final class AppCoordinatorImpl {
	private let authenticationManager: AuthenticationManager
	private let authenticationCoordinatorFactory: (AuthenticationCoordinatorDelegate) -> AuthenticationCoordinator
	private let mainCoordinatorFactory: (MainCoordinatorDelegate) -> MainCoordinator

	private lazy var authenticationCoordinator = authenticationCoordinatorFactory(self)
	private lazy var mainCoordinator = mainCoordinatorFactory(self)

	init(
		authenticationManager: AuthenticationManager,
		authenticationCoordinatorFactory: @escaping (AuthenticationCoordinatorDelegate) -> AuthenticationCoordinator,
		mainCoordinatorFactory: @escaping (MainCoordinatorDelegate) -> MainCoordinator
	) {
		self.authenticationManager = authenticationManager
		self.authenticationCoordinatorFactory = authenticationCoordinatorFactory
		self.mainCoordinatorFactory = mainCoordinatorFactory
	}
}

extension AppCoordinatorImpl: AppCoordinator {
	func start() {
		if authenticationManager.isAuthenticated {
			mainCoordinator.start()
		} else {
			authenticationCoordinator.start()
		}
	}
}

extension AppCoordinatorImpl: AuthenticationCoordinatorDelegate {
	func didFinishAuthentication() {
		mainCoordinator.start()
	}
}

extension AppCoordinatorImpl: MainCoordinatorDelegate {
	func didFinishMain() {
		authenticationCoordinator.start()
	}
}
