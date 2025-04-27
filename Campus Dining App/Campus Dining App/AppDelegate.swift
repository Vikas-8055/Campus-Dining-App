import UIKit
import FirebaseCore        // ← Core contains FirebaseApp

/// The app delegate is used only for early-startup tasks such as
/// Firebase configuration, push-notification callbacks, etc.
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Configure Firebase exactly once, as early as possible.
        FirebaseApp.configure()

        // Optional: make Firebase logs visible while debugging
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        print("✅ Firebase configured →", FirebaseApp.app() as Any)

        return true
    }
}
