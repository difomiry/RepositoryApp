import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct RepositoryTextCellConfiguration {
	let name: String
	let text: String
}

final class RepositoryTextCell: ASCellNode {
	private lazy var name: ASTextNode = {
		return ASTextNode()
	}()

	private lazy var text: ASTextNode = {
		return ASTextNode()
	}()

	init(configuration: RepositoryTextCellConfiguration) {
		super.init()
		name.attributedText = NSAttributedString(
			string: configuration.name,
			attributes: [
				.font: UIFont.boldSystemFont(ofSize: 15)
			]
		)
		text.attributedText = NSAttributedString(
			string: configuration.text,
			attributes: [
				.font: UIFont.systemFont(ofSize: 15)
			]
		)
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
