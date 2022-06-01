import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct SearchSignInOrSignOutCellConfiguration {
	let text: String
}

final class SearchSignInOrSignOutCell: ASCellNode {
	private lazy var text: ASTextNode = {
		return ASTextNode()
	}()

	init(configuration: SearchSignInOrSignOutCellConfiguration) {
		super.init()
		text.attributedText = NSAttributedString(
			string: configuration.text,
			attributes: [
				.font: UIFont.systemFont(ofSize: 15)
			]
		)
		addSubnode(text)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		text.style.width = ASDimension(unit: .points, value: constrainedSize.max.width - 16)
		return ASInsetLayoutSpec(
			insets: .init(top: 8, left: 8, bottom: 8, right: 8),
			child: text
		)
	}
}
