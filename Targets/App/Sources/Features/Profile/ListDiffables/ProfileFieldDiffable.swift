import IGListKit

final class ProfileFieldDiffable: NSObject {
	let text: String

	init(text: String) {
		self.text = text
	}
}

extension ProfileFieldDiffable: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		text as NSObjectProtocol
	}

	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		if self === object { return true }
		guard let object = object as? ProfileFieldDiffable else { return false }
		return text == object.text
	}
}
