import AsyncDisplayKit
import PINRemoteImage
import UIKit

struct ProfileAvatarCellConfiguration {
	let avatar: String
}

final class ProfileAvatarCell: ASCellNode {
	private lazy var avatar: ASNetworkImageNode = .init()

	init(configuration: ProfileAvatarCellConfiguration) {
		super.init()
		avatar.setURL(URL(string: configuration.avatar), resetToDefault: true)
		addSubnode(avatar)
	}

	override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
		avatar.style.preferredLayoutSize = .init(
			width: .init(unit: .points, value: 150),
			height: .init(unit: .points, value: 150)
		)
		let spec = ASCenterLayoutSpec(
			centeringOptions: .X,
			sizingOptions: .minimumX,
			child: avatar
		)
		return ASInsetLayoutSpec(
			insets: .init(
				top: 8,
				left: (constrainedSize.max.width - 150) / 2,
				bottom: 8,
				right: (constrainedSize.max.width - 150) / 2
			),
			child: spec
		)
	}
}
