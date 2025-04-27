// HomeView.swift

import SwiftUI

struct HomeView: View {
  @State private var searchText = ""
  @AppStorage("dietaryPreferences") private var dietaryPreferencesString: String = ""

  private let restaurants = LocalRestaurantService.all

  private var filtered: [LocalRestaurant] {
    guard !searchText.isEmpty else { return restaurants }
    return restaurants.filter {
      $0.name.localizedCaseInsensitiveContains(searchText)
    }
  }

  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        SearchBar(text: $searchText, placeholder: "Search restaurants…")
          .padding(.horizontal).padding(.top)

        ScrollView {
          LazyVStack(spacing: 16) {
            ForEach(filtered) { r in
              NavigationLink(destination: MenuView(restaurant: r)) {
                RestaurantRow(restaurant: r, userPrefs: dietaryPreferencesString)
              }
              .buttonStyle(PlainButtonStyle())
            }
          }
          .padding(.top)
        }
      }
      .navigationTitle("Campus Dining")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

private struct RestaurantRow: View {
  let restaurant: LocalRestaurant
  var userPrefs: String

  var body: some View {
    let prefs = Set(userPrefs.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) })
    let hasMatch = LocalMenuService.all[restaurant.id]?.contains(where: { item in
      !prefs.isEmpty && !prefs.isDisjoint(with: item.dietaryInfo)
    }) ?? false

    HStack(spacing:12) {
      Image(restaurant.imageName)
        .resizable().scaledToFill()
        .frame(width:60, height:60)
        .clipShape(RoundedRectangle(cornerRadius:8))
      VStack(alignment:.leading, spacing:4) {
        Text(restaurant.name).font(.headline)
        Text(restaurant.cuisineType)
          .font(.subheadline).foregroundColor(.secondary)
        if hasMatch {
          Text("🥗 Matches Your Preferences")
            .font(.caption2).foregroundColor(.green)
        }
      }
      Spacer()
      Text(restaurant.isOpen ? "Open" : "Closed")
        .font(.caption.bold())
        .foregroundColor(restaurant.isOpen ? .green : .red)
    }
    .padding(.vertical,8).padding(.horizontal)
    .background(Color(.secondarySystemBackground)).cornerRadius(10)
  }
}

struct SearchBar: View {
  @Binding var text: String
  let placeholder: String
  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
      TextField(placeholder, text: $text).textFieldStyle(.plain)
    }
    .padding(8)
    .background(Color(.secondarySystemBackground))
    .cornerRadius(8)
  }
}
