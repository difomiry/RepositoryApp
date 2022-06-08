import IGListKit

final class ProfileButtonDiffable: NSObject {
	let kind: ProfileViewModel.ButtonKind

	init(kind: ProfileViewModel.ButtonKind) {
		self.kind = kind
	}
}

extension ProfileButtonDiffable: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		("button" + kind.rawValue) as NSObjectProtocol
	}

	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		if self === object { return true }
		guard let object = object as? ProfileButtonDiffable else { return false }
		return kind.rawValue == object.kind.rawValue
	}
}
