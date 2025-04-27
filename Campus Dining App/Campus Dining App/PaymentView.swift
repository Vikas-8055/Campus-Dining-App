import SwiftUI

struct PaymentView: View {
    @Binding var selectedMethod: PaymentMethod?
    let restaurant: LocalRestaurant

    @EnvironmentObject private var dataManager: DataManager
    @EnvironmentObject private var cart: Cart
    @State private var showAlert = false
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            Form {
                Section(header: Text("SELECT PAYMENT METHOD")) {
                    ForEach(PaymentMethod.allCases) { method in
                        HStack {
                            Text(method.rawValue)
                            Spacer()
                            if method == selectedMethod {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { selectedMethod = method }
                    }
                }
            }

            Button("Confirm & Pay") {
                guard let method = selectedMethod else { return }

                let items: [OrderItem] = cart.items.map { menuItem, count in
                    OrderItem(
                        menuItemId: menuItem.id,
                        name:        menuItem.name,
                        price:       menuItem.price,
                        quantity:    count
                    )
                }

                dataManager.placeOrder(
                    restaurantId:   restaurant.id,
                    restaurantName: restaurant.name,
                    items:          items,
                    totalAmount:    cart.totalPrice,
                    paymentMethod:  method.rawValue
                )

                dataManager.selectedTab = 1
                showAlert = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .disabled(selectedMethod == nil || cart.items.isEmpty)
            .alert("Order Placed", isPresented: $showAlert) {
                Button("OK") {
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Your order has been placed successfully.")
            }
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        let sample = LocalRestaurant(
            id:            "1",
            name:          "Sample Diner",
            imageName:     "placeholder-image",
            cuisineType:   "Italian",
            averageRating: 4.2,
            openingTime:   DateComponents(hour: 10, minute: 0),
            closingTime:   DateComponents(hour: 22, minute: 0)
        )

        let firstMethod: PaymentMethod? = PaymentMethod.allCases.first

        return NavigationView {
            PaymentView(
                selectedMethod: .constant(firstMethod),
                restaurant:     sample
            )
            .environmentObject(DataManager.shared)
            .environmentObject(Cart())
        }
    }
}
