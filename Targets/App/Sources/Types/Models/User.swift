import CoreData
import Foundation
import Storage

struct User {
	let id: Int
	let name: String
	let avatar: String
	let followers: Int?
	let following: Int?
}

extension User: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case name = "login"
		case avatar = "avatar_url"
		case followers
		case following
	}
}

extension User: Storable {
	init(object: NSManagedUser) throws {
		self.id = object.id
		self.name = object.name
		self.avatar = object.avatar
		self.followers = object.followers
		self.following = object.following
	}

	func make(with context: NSManagedObjectContext) throws -> NSManagedUser {
		let object = NSManagedUser(context: context)
		object.id = id
		object.name = name
		object.avatar = avatar
		object.followers = followers ?? 0
		object.following = following ?? 0
		return object
	}
}
