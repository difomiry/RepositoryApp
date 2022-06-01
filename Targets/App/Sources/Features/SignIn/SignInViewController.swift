import AsyncDisplayKit

final class SignInViewController: ASDKViewController<SignInNode> {
	private let presenter: SignInPresenter

	init(presenter: SignInPresenter) {
		self.presenter = presenter
		let node = SignInNode(
			presenter: presenter
		)
		presenter.view = node
		super.init(node: node)
	}

	@available(*, unavailable, message: "init(coder:) has not been implemented")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
