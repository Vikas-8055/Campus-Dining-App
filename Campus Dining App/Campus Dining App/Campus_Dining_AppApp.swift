import SwiftUI

@main
struct CampusDiningApp: App {

    // Bridge the UIKit delegate into the SwiftUI lifecycle
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    /// Shared data layer
    @StateObject private var dataManager = DataManager.shared

    var body: some Scene {
        WindowGroup {
            RootRouterView()           // decides between AuthView & Main UI
                .environmentObject(dataManager)
        }
    }
}
