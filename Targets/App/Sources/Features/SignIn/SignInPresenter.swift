import AuthenticationServices
protocol SignInPresenterDelegate: AnyObject {
	func didAuthenticate()
	func didSkip()
}

protocol SignInPresenter: AnyObject {
	var view: SignInView? { get set }
	func didTapSignInButton()
	func didTapSkipButton()
}

final class SignInPresenterImpl {
	private let authenticationManager: AuthenticationManager

	weak var delegate: SignInPresenterDelegate?
	weak var view: SignInView?

	init(
		delegate: SignInPresenterDelegate,
		authenticationManager: AuthenticationManager
	) {
		self.delegate = delegate
		self.authenticationManager = authenticationManager
	}
}

extension SignInPresenterImpl: SignInPresenter {
	func didTapSignInButton() {
		Task {
			do {
				guard let view = view else { return }
				try await authenticationManager.start(with: view)
				Task { @MainActor in
					delegate?.didAuthenticate()
				}
			} catch {
				Task { @MainActor in
					view?.show(error: error)
				}
			}
		}
	}

	func didTapSkipButton() {
		delegate?.didSkip()
	}
}
