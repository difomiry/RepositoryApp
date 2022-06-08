import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct ProfileFieldCellConfiguration {
	let text: String
}

final class ProfileFieldCell: ASCellNode {
	private lazy var text: ASTextNode = .init()

	init(configuration: ProfileFieldCellConfiguration) {
		super.init()
		text.attributedText = NSAttributedString(
			string: configuration.text,
			attributes: [
				.font: UIFont.boldSystemFont(ofSize: 15)
			]
		)
		addSubnode(text)
	}

	override func layoutSpecThatFits(_: ASSizeRange) -> ASLayoutSpec {
		ASCenterLayoutSpec(
			child: text
		)
	}
}
