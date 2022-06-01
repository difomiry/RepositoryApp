import IGListKit

final class SearchSignInOrSignOutDiffable: NSObject {
	enum Kind {
		case signIn
		case signOut
	}

	let kind: Kind

	init(kind: Kind) {
		self.kind = kind
	}
}

extension SearchSignInOrSignOutDiffable: ListDiffable {
	func diffIdentifier() -> NSObjectProtocol {
		"SearchSignInOrSignOutDiffable" as NSObjectProtocol
	}

	func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		object is SearchSignInOrSignOutDiffable
	}
}
