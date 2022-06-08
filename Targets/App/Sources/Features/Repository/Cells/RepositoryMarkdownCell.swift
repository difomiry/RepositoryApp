import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct RepositoryMarkdownCellConfiguration {
	let name: String
	let text: NSAttributedString
}

final class RepositoryMarkdownCell: ASCellNode {
	private lazy var name: ASTextNode = .init()

	private lazy var text: ASTextNode = .init()

	init(configuration: RepositoryMarkdownCellConfiguration) {
		super.init()
		name.attributedText = NSAttributedString(
			string: configuration.name,
			attributes: [
				.font: UIFont.boldSystemFont(ofSize: 15)
			]
		)
		text.attributedText = configuration.text
		addSubnode(name)
		addSubnode(text)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let stack = ASStackLayoutSpec(
			direction: .vertical,
			spacing: 8,
			justifyContent: .start,
			alignItems: .start,
			children: [
				name,
				text
			]
		)
		stack.style.width = ASDimension(unit: .points, value: constrainedSize.max.width - 16)
		return ASInsetLayoutSpec(
			insets: .init(top: 8, left: 8, bottom: 8, right: 8),
			child: stack
		)
	}
}
