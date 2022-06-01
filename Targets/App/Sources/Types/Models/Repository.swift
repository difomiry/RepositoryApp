import Foundation
import CoreData

struct Repository {
	let id: Int
	let name: String
	let description: String?
	let owner: User
	let forks: Int
	let stargazers: Int
	let watchers: Int
	var readme: String?
}

extension Repository: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case description
		case owner
		case forks = "forks_count"
		case stargazers = "stargazers_count"
		case watchers = "watchers_count"
	}
}

extension Repository: Storable {
	init(object: NSManagedRepository) throws {
		self.id = object.id
		self.name = object.name
		self.description = object.desc
		self.owner = User(
			id: object.owner.id,
			name: object.owner.name,
			avatar: object.owner.avatar,
			followers: object.owner.followers,
			following: object.owner.following
		)
		self.forks = object.forks
		self.stargazers = object.stargazers
		self.watchers = object.watchers
		self.readme = object.readme
	}

	func make(with context: NSManagedObjectContext) throws -> NSManagedRepository {
		let object = NSManagedRepository(context: context)
		object.id = id
		object.name = name
		object.desc = description ?? ""
		object.owner = try owner.make(with: context)
		object.forks = forks
		object.stargazers = stargazers
		object.watchers = watchers
		object.readme = readme ?? ""
		return object
	}
}
