import AsyncDisplayKit
import IGListKit

protocol SearchSignInOrSignOutListSectionControllerDelegate: AnyObject {
	func didTapSignIn()
	func didTapSignOut()
}

final class SearchSignInOrSignOutListSectionController: ASListSectionController<SearchSignInOrSignOutDiffable> {
	private weak var delegate: SearchSignInOrSignOutListSectionControllerDelegate?

	init(delegate: SearchSignInOrSignOutListSectionControllerDelegate) {
		self.delegate = delegate
	}

	override func didSelectItem(at index: Int) {
		guard let object = object else { return }
		switch object.kind {
		case .signIn:
			delegate?.didTapSignIn()
		case .signOut:
			delegate?.didTapSignOut()
		}
	}

	override func nodeForItem(at index: Int) -> ASCellNode {
		guard let object = object else { return ASCellNode() }
		return SearchSignInOrSignOutCell(
			configuration: SearchSignInOrSignOutCellConfiguration(
				text: object.kind == .signIn ? "Sign In" : "Sign Out"
			)
		)
	}
}
