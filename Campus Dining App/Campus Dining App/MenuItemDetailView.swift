import SwiftUI

struct MenuItemDetailView: View {
    let menuItem: MenuItem
    let restaurant: Restaurant

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: menuItem.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 200)
                .cornerRadius(12)

                Text(menuItem.name)
                    .font(.title)
                    .fontWeight(.bold)

                Text(menuItem.description)
                    .font(.body)
                    .padding(.top, 8)

                HStack {
                    Text("$\(menuItem.price, specifier: "%.2f")")
                        .font(.headline)

                    Spacer()

                    Button("Add to Cart") {
                        // TODO: add‑to‑cart logic
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(menuItem.name)
    }
}

// MARK: - Preview

// MARK: - Preview

#if DEBUG
struct MenuItemDetailView_Previews: PreviewProvider {
    // Build sample data OUTSIDE the ViewBuilder
    static let sampleItem = MenuItem(
        id: "1",
        name: "Example Dish",
        description: "Delicious sample",              // description comes right after name
        price: 9.99,
        imageURL: "https://via.placeholder.com/150",  // URL comes right after description
        restaurantId: "r1",                           // then restaurant reference
                                       // price must precede category
        category: "Sample",
        isAvailable: true,  // then category
        dietaryInfo: [],                              // then dietary info
                                  // then availability
     
        preparationTime: Int(10.0)                         // finally preparation time
    )

    static let sampleRestaurant = Restaurant(
           id: "r1",
           name: "Sample Resto",
           description: "Tasty food here.",   // description comes right after name
           imageURL: "",                      // next comes imageURL
           location: "Campus",                // then location
           hours: "9 AM–8 PM",     // then hoursOfOperation
           cuisineType: "Global",             // then cuisineType
           averageRating: 4.5                 // finally averageRating
       )
    

    static var previews: some View {
        NavigationView {
            MenuItemDetailView(
                menuItem: sampleItem,
                restaurant: sampleRestaurant
            )
            // .environmentObject(DataManager.preview)  // if you need a mock DataManager
        }
    }
}
#endif


