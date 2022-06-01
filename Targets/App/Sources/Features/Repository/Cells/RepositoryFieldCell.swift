import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct RepositoryFieldCellConfiguration {
	let name: String
	let value: String
}

final class RepositoryFieldCell: ASCellNode {
	private lazy var name: ASTextNode = {
		return ASTextNode()
	}()

	private lazy var value: ASTextNode = {
		return ASTextNode()
	}()

	init(configuration: RepositoryFieldCellConfiguration) {
		super.init()
		name.attributedText = NSAttributedString(
			string: configuration.name,
			attributes: [
				.font: UIFont.boldSystemFont(ofSize: 15)
			]
		)
		value.attributedText = NSAttributedString(
			string: configuration.value,
			attributes: [
				.font: UIFont.systemFont(ofSize: 15)
			]
		)
		addSubnode(name)
		addSubnode(value)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		let stack = ASStackLayoutSpec(
			direction: .horizontal,
			spacing: 8,
			justifyContent: .spaceBetween,
			alignItems: .center,
			children: [
				name,
				value
			]
		)
		stack.style.width = ASDimension(unit: .points, value: constrainedSize.max.width - 16)
		return ASInsetLayoutSpec(
			insets: .init(top: 8, left: 8, bottom: 8, right: 8),
			child: stack
		)
	}
}
