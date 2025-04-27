import SwiftUI

struct CartView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @State private var showingClearAlert = false

    var body: some View {
        VStack(spacing: 20) {
            if dataManager.cartManager.itemCount == 0 {
                Text("Your cart is empty")
            } else {
                Text("Items: \(dataManager.cartManager.itemCount)")

                Button("Checkout") {
                    // kick off your payment flow here
                }
                .buttonStyle(.borderedProminent)

                Button("Clear Cart") {
                    showingClearAlert = true
                }
                .foregroundColor(.red)
                .alert("Clear Cart?", isPresented: $showingClearAlert) {
                    Button("Clear", role: .destructive) {
                        dataManager.cartManager.clearCart()  // ✅ FIXED
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Are you sure you want to remove all items?")
                }

            }
        }
        .padding()
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(DataManager.shared)
    }
}
