import UIKit
import AsyncDisplayKit

protocol MainCoordinatorDelegate: AnyObject {
	func didFinishMain()
}

protocol MainCoordinator {
	func start()
}

final class MainCoordinatorImpl {
	private let window: UIWindow
	private let searchViewControllerFactory: (SearchPresenterDelegate) -> SearchViewController
	private let repositoryViewControllerFactory: (Repository) -> RepositoryViewController

	weak var delegate: MainCoordinatorDelegate?
	private weak var searchNavigationController: ASDKNavigationController?

	init(
		window: UIWindow,
		searchViewControllerFactory: @escaping (SearchPresenterDelegate) -> SearchViewController,
		repositoryViewControllerFactory: @escaping (Repository) -> RepositoryViewController
	) {
		self.window = window
		self.searchViewControllerFactory = searchViewControllerFactory
		self.repositoryViewControllerFactory = repositoryViewControllerFactory
	}
}

extension MainCoordinatorImpl: MainCoordinator {
	func start() {
		let searchNavigationController = ASDKNavigationController(rootViewController: searchViewControllerFactory(self))
		self.searchNavigationController = searchNavigationController
		window.rootViewController = searchNavigationController
		window.makeKeyAndVisible()
	}
}

extension MainCoordinatorImpl: SearchPresenterDelegate {
	func didTap(repository: Repository) {
		let viewController = repositoryViewControllerFactory(repository)
		searchNavigationController?.pushViewController(viewController, animated: true)
	}
	
	func didFinishSearch() {
		delegate?.didFinishMain()
	}
}
