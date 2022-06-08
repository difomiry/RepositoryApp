import CoreData

public protocol Storable {
	associatedtype NSManagedType: NSManagedObject
	init(object: NSManagedType) throws
	func make(with context: NSManagedObjectContext) throws -> NSManagedType
}
