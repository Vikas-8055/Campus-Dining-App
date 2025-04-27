import SwiftUI

struct MenuView: View {
    let restaurant: LocalRestaurant
    @StateObject private var cart = Cart()
    @State private var searchText = ""

    @AppStorage("dietaryPreferences") private var dietaryPreferencesRaw = ""

    private var menuItems: [LocalMenuItem] {
        LocalMenuService.all[restaurant.id] ?? []
    }

    private var dietaryPreferences: Set<String> {
        Set(dietaryPreferencesRaw.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) })
    }

    private var filteredItems: [LocalMenuItem] {
        menuItems.filter { item in
            let matchesSearch = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            let matchesDietary = dietaryPreferences.isEmpty || !dietaryPreferences.isDisjoint(with: Set(item.dietaryInfo))
            return matchesSearch && matchesDietary
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $searchText, placeholder: "Search menu…")
                .padding()

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredItems) { item in
                        MenuItemRow(item: item, cart: cart)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }

            if cart.totalItems > 0 {
                VStack(spacing: 10) {
                    NavigationLink(destination: CheckoutView(cart: cart, restaurant: restaurant)) {
                        HStack {
                            Text("\(cart.totalItems) item\(cart.totalItems > 1 ? "s" : "")").bold()
                            Text("• $\(cart.totalPrice, specifier: "%.2f")").bold()
                            Spacer()
                            Text("Checkout")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                        .padding()
                        .background(Color(.systemBackground).shadow(radius: 2))
                    }

                    Button("Clear Cart") {
                        cart.clear()
                    }
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
                }
            }
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
