import CoreData

final class StorageManagerImpl {
	private let persistentContainer: NSPersistentContainer

	init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}
}

extension StorageManagerImpl: StorageManager {
	func fetch<T>() async throws -> T where T: Storable {
		let fetchRequest = T.NSManagedType.fetchRequest()
		fetchRequest.fetchLimit = 1
		let results = try persistentContainer.viewContext.fetch(fetchRequest)
		guard let object = results.first
		else {
			throw StorageError.notFound
		}
		guard let managedType = object as? T.NSManagedType
		else {
			throw StorageError.typeMismatch
		}
		return try .init(object: managedType)
	}

	func fetch<T>() async throws -> [T] where T: Storable {
		let fetchRequest = T.NSManagedType.fetchRequest()
		let results = try persistentContainer.viewContext.fetch(fetchRequest)
		return try results.compactMap { $0 as? T.NSManagedType }.map(T.init)
	}

	func save<T>(_ value: T) async throws where T: Storable {
		let context = persistentContainer.newBackgroundContext()
		_ = try value.make(with: context)
		try context.save()
	}

	func clear<T>(type: T.Type) async throws where T: Storable {
		let fetchRequest = T.NSManagedType.fetchRequest()
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		let context = persistentContainer.newBackgroundContext()
		try context.execute(deleteRequest)
		try context.save()
	}
}
