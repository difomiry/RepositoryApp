import SwiftDI
import UIKit

@main
final class AppDelegate: UIResponder {
	var window: UIWindow?
	var coordinator: AppCoordinator!
}

extension AppDelegate: UIApplicationDelegate {
	func application(
		_: UIApplication,
		didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		guard let window = window else { return true }
		do {
			coordinator = Context.resolve(
				dependency: try .live(window: window),
				factory: makeAppCoordinator
			)
			coordinator?.start()
		} catch {}
		return true
	}
}
