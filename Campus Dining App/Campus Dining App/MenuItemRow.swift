import SwiftUI

/// Your reusable menu‐item row
struct MenuItemRow: View {
    let item: LocalMenuItem
    @ObservedObject var cart: Cart

    var body: some View {
        HStack {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name).font(.headline)
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.subheadline.bold())

                // Optional: Show dietary tags
                if !item.dietaryInfo.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(item.dietaryInfo, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.green.opacity(0.2))
                                    .foregroundColor(.green)
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
            }

            Spacer()

            HStack(spacing: 6) {
                Button { cart.remove(item) } label: {
                    Image(systemName: "minus.circle")
                }
                Text("\(cart.items[item] ?? 0)")
                    .frame(minWidth: 20)
                Button { cart.add(item) } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .font(.title3)
        }
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

#if DEBUG
struct MenuItemRow_Previews: PreviewProvider {
    static var previews: some View {
        let dummy = LocalMenuItem(
            id: "1-1", restaurantID: "1",
            name: "Sample", description: "Desc",
            price: 9.99, imageName: "choolah_chicken",
            dietaryInfo: ["Vegan", "Gluten-Free"]
        )
        let cart = Cart()
        cart.add(dummy)

        return MenuItemRow(item: dummy, cart: cart)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
