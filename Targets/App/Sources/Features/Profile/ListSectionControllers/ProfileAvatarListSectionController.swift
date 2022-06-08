import AsyncDisplayKit
import IGListKit

protocol ProfileAvatarListSectionControllerDelegate: AnyObject {}

final class ProfileAvatarListSectionController: ASListSectionController<ProfileAvatarDiffable> {
	private weak var delegate: ProfileAvatarListSectionControllerDelegate?

	init(delegate: ProfileAvatarListSectionControllerDelegate) {
		self.delegate = delegate
	}

	override func nodeForItem(at index: Int) -> ASCellNode {
		guard let object = object else { return ASCellNode() }
		return ProfileAvatarCell(
			configuration: ProfileAvatarCellConfiguration(
				avatar: object.avatar
			)
		)
	}
}
