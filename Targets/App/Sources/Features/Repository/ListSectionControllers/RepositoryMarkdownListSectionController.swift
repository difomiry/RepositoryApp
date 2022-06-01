import AsyncDisplayKit
import IGListKit

protocol RepositoryMarkdownListSectionControllerDelegate: AnyObject {}

final class RepositoryMarkdownListSectionController: ASListSectionController<RepositoryMarkdownDiffable> {
	private weak var delegate: RepositoryMarkdownListSectionControllerDelegate?

	init(delegate: RepositoryMarkdownListSectionControllerDelegate) {
		self.delegate = delegate
	}

	override func nodeForItem(at index: Int) -> ASCellNode {
		guard let object = object else { return ASCellNode() }
		return RepositoryMarkdownCell(
			configuration: RepositoryMarkdownCellConfiguration(
				name: object.name,
				text: object.text
			)
		)
	}
}
