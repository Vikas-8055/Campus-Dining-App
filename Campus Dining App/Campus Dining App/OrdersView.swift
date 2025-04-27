// OrdersView.swift

import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack {
                if !dataManager.isAuthenticated {
                    notSignedInView
                } else {
                    ordersContent
                }
            }
            .navigationTitle("My Orders")
            .onAppear { dataManager.fetchOrders() }
        }
    }

    private var notSignedInView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("Sign in to view your orders")
                .font(.title2)
            NavigationLink(destination: AuthView()) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 50)
            }
        }
        .padding()
    }

    private var ordersContent: some View {
        VStack {
            Picker("Orders", selection: $selectedTab) {
                Text("Active").tag(0)
                Text("Past").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if selectedTab == 0 {
                if dataManager.currentOrders.isEmpty {
                    emptyStateView("You have no active orders")
                } else {
                    List(dataManager.currentOrders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderRow(order: order)
                        }
                    }
                }
            } else {
                if dataManager.pastOrders.isEmpty {
                    emptyStateView("You have no past orders")
                } else {
                    List(dataManager.pastOrders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            OrderRow(order: order)
                        }
                    }
                }
            }
        }
    }

    private func emptyStateView(_ msg: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "bag")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text(msg)
                .font(.headline)
                .foregroundColor(.gray)
            NavigationLink(destination: HomeView().environmentObject(dataManager)) {
                Text("Browse Menu")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct OrderRow: View {
    let order: Order

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(order.restaurantName)
                    .font(.headline)
                Text("\(order.items.count) items · \(order.formattedPlacedTime)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(order.status.rawValue.capitalized)
                    .font(.caption)
                    .padding(6)
                    .background(statusColor(for: order.status).opacity(0.2))
                    .foregroundColor(statusColor(for: order.status))
                    .cornerRadius(8)
                Text("$\(order.totalAmount, specifier: "%.2f")")
                    .font(.headline)
            }
        }
    }

    private func statusColor(for status: OrderStatus) -> Color {
        switch status {
        case .pending:   return .orange
        case .preparing: return .blue
        case .ready:     return .green
        case .completed: return .gray
        case .cancelled: return .red
        }
    }
}
