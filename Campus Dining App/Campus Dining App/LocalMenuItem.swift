import Foundation

struct LocalMenuItem: Identifiable, Hashable {
    let id: String
    let restaurantID: String   // matches Restaurant.id
    let name: String
    let description: String
    let price: Double
    let imageName: String      // Asset image name
    let dietaryInfo: [String]  // e.g., ["Vegan", "Gluten-Free"]
}
