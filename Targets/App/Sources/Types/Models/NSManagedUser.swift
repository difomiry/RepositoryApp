import CoreData

@objc(User)
public class NSManagedUser: NSManagedObject {
	@NSManaged public var id: Int
	@NSManaged public var name: String
	@NSManaged public var avatar: String
	@NSManaged public var followers: Int
	@NSManaged public var following: Int
}

extension NSManagedUser {
	public class func fetchRequest() -> NSFetchRequest<NSManagedUser> {
		NSFetchRequest<NSManagedUser>(entityName: "User")
	}
}
