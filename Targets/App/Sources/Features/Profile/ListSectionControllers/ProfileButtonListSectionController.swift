import AsyncDisplayKit
import IGListKit

protocol ProfileButtonListSectionControllerDelegate: AnyObject {
	func didTapButton(kind: ProfileViewModel.ButtonKind)
}

final class ProfileButtonListSectionController: ASListSectionController<ProfileButtonDiffable> {
	private weak var delegate: ProfileButtonListSectionControllerDelegate?

	init(delegate: ProfileButtonListSectionControllerDelegate) {
		self.delegate = delegate
	}

	override func didSelectItem(at index: Int) {
		guard let object = object else { return }
		delegate?.didTapButton(kind: object.kind)
	}

	override func nodeForItem(at index: Int) -> ASCellNode {
		guard let object = object else { return ASCellNode() }
		return ProfileButtonCell(
			configuration: ProfileButtonCellConfiguration(
				title: object.kind.rawValue
			)
		)
	}
}
