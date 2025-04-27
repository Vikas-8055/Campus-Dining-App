// OrderDetailView.swift

import SwiftUI

struct OrderDetailView: View {
    let order: Order

    @EnvironmentObject private var dataManager: DataManager
    @State private var showingCancelAlert = false

    var canCancel: Bool {
        order.status == .pending || order.status == .preparing
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Restaurant: \(order.restaurantName)")
                    .font(.headline)
                Text("Status: \(order.status.rawValue.capitalized)")
                Text("Placed: \(order.placedTime, formatter: dateFormatter)")
                Text("Ready:  \(order.estimatedReadyTime, formatter: dateFormatter)")
                Divider()
                ForEach(order.items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("×\(item.quantity)")
                    }
                }
            }
            .padding()

            if canCancel {
                Button("Cancel Order") {
                    showingCancelAlert = true
                }
                .alert("Cancel Order", isPresented: $showingCancelAlert) {
                    Button("No", role: .cancel) {}
                    Button("Yes", role: .destructive) {
                        dataManager.cancelOrder(orderId: order.id ?? "") { _ in }
                    }
                } message: {
                    Text("Are you sure you want to cancel this order?")
                }
                .padding()
            }
        }
        .navigationTitle("Order Details")
    }
}

// Date formatter helper
private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .short
    return df
}()
