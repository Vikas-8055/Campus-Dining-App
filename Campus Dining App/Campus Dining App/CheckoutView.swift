import SwiftUI

struct CheckoutView: View {
    @ObservedObject var cart: Cart
    let restaurant: LocalRestaurant

    @State private var showingPayment = false
    @State private var selectedMethod: PaymentMethod?
    @State private var showingClearAlert = false

    private var lineItems: [(item: LocalMenuItem, count: Int)] {
        cart.items.map { ($0.key, $0.value) }
    }
    private var total: Double { cart.totalPrice }

    var body: some View {
        VStack(spacing: 16) {
            List {
                ForEach(lineItems, id: \.item.id) { line in
                    HStack {
                        Text(line.item.name)
                        Spacer()
                        Text("×\(line.count)")
                        Text("$\(Double(line.count) * line.item.price, specifier: "%.2f")")
                    }
                }
            }

            HStack {
                Text("Total").font(.headline)
                Spacer()
                Text("$\(total, specifier: "%.2f")").font(.headline)
            }
            .padding(.horizontal)

            Button("Proceed to Payment") {
                showingPayment = true
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .disabled(cart.items.isEmpty)

            Button("Clear Cart") {
                showingClearAlert = true
            }
            .foregroundColor(.red)
            .padding(.horizontal)
            .alert("Clear Cart?", isPresented: $showingClearAlert) {
                Button("Clear", role: .destructive) {
                    cart.clear()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to remove all items from the cart?")
            }

            Spacer()
        }
        .navigationTitle("Checkout")
        .background(
            NavigationLink(
                destination:
                    PaymentView(
                        selectedMethod: $selectedMethod,
                        restaurant: restaurant
                    )
                    .environmentObject(cart)
                    .environmentObject(DataManager.shared),
                isActive: $showingPayment
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
}
