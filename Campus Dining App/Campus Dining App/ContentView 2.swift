import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var dataManager: DataManager
    @ObservedObject private var notificationManager = NotificationManager.shared
    @State private var homePath = NavigationPath()

    var body: some View {
        ZStack {
            TabView(selection: $dataManager.selectedTab) {
                NavigationStack(path: $homePath) {
                    HomeView()
                        .navigationDestination(for: LocalRestaurant.self) { restaurant in
                            MenuView(restaurant: restaurant)
                        }
                }
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)
                .onChange(of: dataManager.selectedTab) { newValue in
                    if newValue == 0 {
                        // Also reset cart when going home to avoid showing lingering checkout state
                        dataManager.cartManager.clearCart()
                        homePath = NavigationPath() // Reset to root
                    }
                }

                OrdersView()
                    .tabItem {
                        Label("Orders", systemImage: "bag")
                            .badge(dataManager.hasOrderUpdates ? "" : nil)
                    }
                    .tag(1)
                    .onAppear { dataManager.viewedOrders() }

                ProfileView()
                    .tabItem { Label("Profile", systemImage: "person") }
                    .tag(2)
            }

            VStack {
                NotificationCenterView()
                Spacer()
            }
            .padding(.top)
        }
        .onAppear {
            NotificationService.shared.requestPermission { _ in }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataManager.shared)
    }
}
