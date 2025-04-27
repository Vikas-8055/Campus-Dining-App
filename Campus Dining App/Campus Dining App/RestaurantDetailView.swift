//
//  RestaurantDetailView.swift
//  Campus Dining App
//
//  Updated by ChatGPT on 2025-04-25
//

import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: Restaurant
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedCategory: String?
    @State private var showingCart = false

    // Build the list of categories from your fetched menu items
    private var categories: [String] {
        Array(Set(dataManager.menuItems.map { $0.category })).sorted()
    }

    // Filter the items by the selected category (or show all)
    private var filteredItems: [MenuItem] {
        if let selected = selectedCategory {
            return dataManager.menuItems
                .filter { $0.category == selected && $0.isAvailable }
        }
        return dataManager.menuItems.filter { $0.isAvailable }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                restaurantHeaderSection

                Divider()

                infoSection

                Divider()

                categoriesSection

                menuItemsSection

                // Cart button
                if dataManager.cartManager.itemCount > 0 {
                    Button {
                        showingCart = true
                    } label: {
                        HStack {
                            Image(systemName: "cart.fill")
                            Text("View Cart (\(dataManager.cartManager.itemCount) items)")
                            Spacer()
                            Text("$\(dataManager.cartManager.totalAmount, specifier: "%.2f")")
                        }
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .navigationTitle(restaurant.name)
        .onAppear {
            if let id = restaurant.id {
                dataManager.fetchMenuItems(for: id)
            }
        }
        .sheet(isPresented: $showingCart) {
            CartView()
                .environmentObject(dataManager)
        }
    }

    // MARK: – Header
    private var restaurantHeaderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: restaurant.imageURL)) { img in
                img.resizable()
                   .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 200)
            .cornerRadius(12)

            Text(restaurant.name)
                .font(.title).bold()

            HStack(spacing: 4) {
                Image(systemName: "star.fill").foregroundColor(.yellow)
                Text("\(restaurant.averageRating, specifier: "%.1f")")
                Text("·")
                Text(restaurant.cuisineType).foregroundColor(.secondary)
            }
            .font(.subheadline)

            Text(restaurant.description)
                .font(.body)
                .padding(.top, 4)
        }
    }

    // MARK: – Info (location & hours)
    private var infoSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Label(restaurant.location, systemImage: "location")
                Label(restaurant.hours,    systemImage: "clock")
            }
            .font(.subheadline)

            Spacer()

            Button {
                // directions action
            } label: {
                Label("Directions", systemImage: "map")
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
    }

    // MARK: – Categories
    private var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryButton(
                    title: "All",
                    isSelected: selectedCategory == nil
                ) { selectedCategory = nil }

                ForEach(categories, id: \.self) { cat in
                    CategoryButton(
                        title: cat,
                        isSelected: selectedCategory == cat
                    ) { selectedCategory = cat }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: – Menu Items
    private var menuItemsSection: some View {
        LazyVStack(alignment: .leading, spacing: 16) {
            ForEach(filteredItems) { item in
                NavigationLink(
                    destination: MenuItemDetailView(menuItem: item, restaurant: restaurant)
                ) {
                    // 👇 Use the in-file DetailMenuItemRow, not the standalone local one
                    DetailMenuItemRow(menuItem: item)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
    }
}

// MARK: – Category Button

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// MARK: – DetailMenuItemRow

/// This is your FIRESTORE-based row for `MenuItem`
/// (renamed so it won’t conflict with your local `MenuItemRow.swift`)
struct DetailMenuItemRow: View {
    let menuItem: MenuItem

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: menuItem.imageURL)) { img in
                img.resizable()
                   .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(menuItem.name).font(.headline)
                Text(menuItem.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack {
                    ForEach(menuItem.dietaryInfo.prefix(3), id: \.self) { info in
                        Text(info)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                }
            }

            Spacer()

            Text("$\(menuItem.price, specifier: "%.2f")")
                .font(.headline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
