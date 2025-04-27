import SwiftUI

struct RootRouterView: View {
    @EnvironmentObject private var dataManager: DataManager

    var body: some View {
        Group {
            if dataManager.isAuthenticated {
                ContentView()
            } else {
                AuthView()
            }
        }
        .animation(.easeInOut, value: dataManager.isAuthenticated)
        .transition(.opacity)
    }
}
