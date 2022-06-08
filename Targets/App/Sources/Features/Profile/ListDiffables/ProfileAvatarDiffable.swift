import IGListKit

final class ProfileAvatarDiffable: NSObject {
	let avatar: String

	init(avatar: String) {
		self.avatar = avatar
	}
}

extension ProfileAvatarDiffable: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		avatar as NSObjectProtocol
	}

	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		if self === object { return true }
		guard let object = object as? ProfileAvatarDiffable else { return false }
		return avatar == object.avatar
	}
}
