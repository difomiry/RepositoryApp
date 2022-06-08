import AuthenticationServices
import UIKit

protocol AuthenticationCoordinatorDelegate: AnyObject {
	func didFinishAuthentication()
}

protocol AuthenticationCoordinator {
	func start()
}

final class AuthenticationCoordinatorImpl {
	private let window: UIWindow
	private let signInViewControllerFactory: (SignInPresenterDelegate) -> SignInViewController

	weak var delegate: AuthenticationCoordinatorDelegate?

	init(
		window: UIWindow,
		signInViewControllerFactory: @escaping (SignInPresenterDelegate) -> SignInViewController
	) {
		self.window = window
		self.signInViewControllerFactory = signInViewControllerFactory
	}
}

extension AuthenticationCoordinatorImpl: AuthenticationCoordinator {
	func start() {
		window.rootViewController = signInViewControllerFactory(self)
		window.makeKeyAndVisible()
	}
}

extension AuthenticationCoordinatorImpl: SignInPresenterDelegate {
	func didAuthenticate() {
		delegate?.didFinishAuthentication()
	}

	func didSkip() {
		delegate?.didFinishAuthentication()
	}
}
