import CoreData

public final class StorageManagerImpl {
	private let persistentContainer: NSPersistentContainer

	public init(persistentContainer: NSPersistentContainer) {
		self.persistentContainer = persistentContainer
	}
}

extension StorageManagerImpl: StorageManager {
	public func fetch<T>() async throws -> T where T: Storable {
		try await withCheckedThrowingContinuation { continuation in
			persistentContainer.performBackgroundTask { context in
				do {
					let fetchRequest = T.NSManagedType.fetchRequest()
					fetchRequest.fetchLimit = 1
					let results = try context.fetch(fetchRequest)
					guard let object = results.first
					else {
						throw StorageError.notFound
					}
					guard let managedType = object as? T.NSManagedType
					else {
						throw StorageError.typeMismatch
					}
					continuation.resume(returning: try .init(object: managedType))
				} catch {
					continuation.resume(throwing: error)
				}
			}
		}
	}

	public func fetch<T>() async throws -> [T] where T: Storable {
		try await withCheckedThrowingContinuation { continuation in
			persistentContainer.performBackgroundTask { context in
				do {
					let fetchRequest = T.NSManagedType.fetchRequest()
					let results = try context.fetch(fetchRequest)
					continuation.resume(returning: try results.compactMap { $0 as? T.NSManagedType }.map(T.init))
				} catch {
					continuation.resume(throwing: error)
				}
			}
		}
	}

	public func save<T>(_ value: T) async throws where T: Storable {
		try await withCheckedThrowingContinuation { continuation in
			persistentContainer.performBackgroundTask { context in
				do {
					_ = try value.make(with: context)
					try context.save()
					continuation.resume()
				} catch {
					continuation.resume(throwing: error)
				}
			}
		}
	}

	public func clear<T>(type: T.Type) async throws where T: Storable {
		try await withCheckedThrowingContinuation { continuation in
			persistentContainer.performBackgroundTask { context in
				do {
					let fetchRequest = T.NSManagedType.fetchRequest()
					let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
					try context.execute(deleteRequest)
					try context.save()
					continuation.resume()
				} catch {
					continuation.resume(throwing: error)
				}
			}
		}
	}
}
