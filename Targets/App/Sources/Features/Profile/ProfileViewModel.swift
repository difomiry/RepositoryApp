struct ProfileViewModel {
	let items: [Item]
}

extension ProfileViewModel {
	enum Item {
		case avatar(avatar: String)
		case field(text: String)
		case button(kind: ButtonKind)
	}
}

extension ProfileViewModel {
	enum ButtonKind: String {
		case signIn = "Sign In"
		case signOut = "Sign Out"
	}
}
