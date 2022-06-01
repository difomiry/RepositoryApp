import AsyncDisplayKit
import IGListKit

protocol RepositoryFieldListSectionControllerDelegate: AnyObject {}

final class RepositoryFieldListSectionController: ASListSectionController<RepositoryFieldDiffable> {
	private weak var delegate: RepositoryFieldListSectionControllerDelegate?

	init(delegate: RepositoryFieldListSectionControllerDelegate) {
		self.delegate = delegate
	}

	override func nodeForItem(at index: Int) -> ASCellNode {
		guard let object = object else { return ASCellNode() }
		return RepositoryFieldCell(
			configuration: RepositoryFieldCellConfiguration(
				name: object.name,
				value: object.value
			)
		)
	}
}
