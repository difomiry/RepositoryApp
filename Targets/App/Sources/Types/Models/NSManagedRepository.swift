import CoreData

@objc(Repository)
public class NSManagedRepository: NSManagedObject {
	@NSManaged public var id: Int
	@NSManaged public var name: String
	@NSManaged public var language: String
	@NSManaged public var desc: String
	@NSManaged public var owner: NSManagedUser
	@NSManaged public var forks: Int
	@NSManaged public var stargazers: Int
	@NSManaged public var watchers: Int
	@NSManaged public var readme: String
}

public extension NSManagedRepository {
	class func fetchRequest() -> NSFetchRequest<NSManagedRepository> {
		NSFetchRequest<NSManagedRepository>(entityName: "Repository")
	}
}
