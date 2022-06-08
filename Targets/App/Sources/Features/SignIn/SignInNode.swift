import AsyncDisplayKit
import AuthenticationServices

protocol SignInView: ASWebAuthenticationPresentationContextProviding {
	func show(error: Error)
}

final class SignInNode: ASDisplayNode {
	private lazy var signInButton: ASButtonNode = {
		let node = ASButtonNode()
		node.cornerRadius = 8
		node.backgroundColor = .systemBlue
		node.setTitle(
			"Sign In",
			with: .systemFont(ofSize: 20),
			with: .white,
			for: .normal
		)
		node.addTarget(
			self,
			action: #selector(didTapSignInButton),
			forControlEvents: .touchUpInside
		)
		return node
	}()

	private lazy var skipButtonButton: ASButtonNode = {
		let node = ASButtonNode()
		node.cornerRadius = 8
		node.backgroundColor = .systemGray
		node.setTitle(
			"Skip",
			with: .systemFont(ofSize: 20),
			with: .white,
			for: .normal
		)
		node.addTarget(
			self,
			action: #selector(didTapSkipButton),
			forControlEvents: .touchUpInside
		)
		return node
	}()

	private let presenter: SignInPresenter

	init(presenter: SignInPresenter) {
		self.presenter = presenter
		super.init()
		automaticallyManagesSubnodes = true
		automaticallyRelayoutOnSafeAreaChanges = true
		backgroundColor = .white
	}

	@available(*, unavailable, message: "init(coder:) has not been implemented")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		signInButton.style.preferredSize = .init(
			width: constrainedSize.max.width - 32,
			height: 56
		)
		skipButtonButton.style.preferredSize = .init(
			width: constrainedSize.max.width - 32,
			height: 56
		)
		let stackSpec = ASStackLayoutSpec(
			direction: .vertical,
			spacing: 8,
			justifyContent: .center,
			alignItems: .center,
			children: [
				signInButton,
				skipButtonButton
			]
		)
		let spec = ASRelativeLayoutSpec(
			horizontalPosition: .center,
			verticalPosition: .end,
			sizingOption: .minimumHeight,
			child: stackSpec
		)
		return ASInsetLayoutSpec(
			insets: .init(
				top: 8,
				left: 8,
				bottom: 8 + safeAreaInsets.bottom,
				right: 8
			),
			child: spec
		)
	}

	@objc func didTapSignInButton() {
		presenter.didTapSignInButton()
	}

	@objc func didTapSkipButton() {
		presenter.didTapSkipButton()
	}
}

extension SignInNode: SignInView {
	func presentationAnchor(
		for session: ASWebAuthenticationSession
	) -> ASPresentationAnchor {
		let window = UIApplication.shared.windows.first { $0.isKeyWindow }
		return window ?? ASPresentationAnchor()
	}

	func show(error: Error) {
		let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
		alert.addAction(.init(title: "Ok", style: .default))
		closestViewController?.present(alert, animated: true)
	}
}
