import AsyncDisplayKit
import UIKit

protocol MainCoordinatorDelegate: AnyObject {
	func didFinishMain()
}

protocol MainCoordinator {
	func start()
}

final class MainCoordinatorImpl {
	private let window: UIWindow
	private let searchViewControllerFactory: (SearchPresenterDelegate) -> SearchViewController
	private let profileViewControllerFactory: (ProfilePresenterDelegate) -> ProfileViewController
	private let repositoryViewControllerFactory: (Repository) -> RepositoryViewController

	weak var delegate: MainCoordinatorDelegate?
	private weak var searchNavigationController: ASDKNavigationController?

	init(
		window: UIWindow,
		searchViewControllerFactory: @escaping (SearchPresenterDelegate) -> SearchViewController,
		profileViewControllerFactory: @escaping (ProfilePresenterDelegate) -> ProfileViewController,
		repositoryViewControllerFactory: @escaping (Repository) -> RepositoryViewController
	) {
		self.window = window
		self.searchViewControllerFactory = searchViewControllerFactory
		self.profileViewControllerFactory = profileViewControllerFactory
		self.repositoryViewControllerFactory = repositoryViewControllerFactory
	}
}

extension MainCoordinatorImpl: MainCoordinator {
	func start() {
		let searchNavigationController = ASDKNavigationController(rootViewController: searchViewControllerFactory(self))
		self.searchNavigationController = searchNavigationController
		let profileNavigationController = ASDKNavigationController(rootViewController: profileViewControllerFactory(self))
		let tabBarController = ASTabBarController()
		tabBarController.viewControllers = [
			searchNavigationController,
			profileNavigationController
		]
		window.rootViewController = tabBarController
		window.makeKeyAndVisible()
	}
}

extension MainCoordinatorImpl: SearchPresenterDelegate {
	func didTap(repository: Repository) {
		let viewController = repositoryViewControllerFactory(repository)
		searchNavigationController?.pushViewController(viewController, animated: true)
	}
}

extension MainCoordinatorImpl: ProfilePresenterDelegate {
	func didFinishProfile() {
		delegate?.didFinishMain()
	}
}
