import AsyncDisplayKit
import IGListKit

protocol ProfileFieldListSectionControllerDelegate: AnyObject {}

final class ProfileFieldListSectionController: ASListSectionController<ProfileFieldDiffable> {
	private weak var delegate: ProfileFieldListSectionControllerDelegate?

	init(delegate: ProfileFieldListSectionControllerDelegate) {
		self.delegate = delegate
	}

	override func nodeForItem(at index: Int) -> ASCellNode {
		guard let object = object else { return ASCellNode() }
		return ProfileFieldCell(
			configuration: ProfileFieldCellConfiguration(
				text: object.text
			)
		)
	}
}
