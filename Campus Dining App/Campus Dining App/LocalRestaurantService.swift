import Foundation

/// Your five sample restaurants (Model + Service combined)
struct LocalRestaurant: Identifiable, Hashable {
    let id: String
    let name: String
    let imageName: String
    let cuisineType: String
    let averageRating: Double
    let openingTime: DateComponents
    let closingTime: DateComponents

    var isOpen: Bool {
        let now = Date()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)

        guard
            let open = calendar.date(byAdding: openingTime, to: today),
            let close = calendar.date(byAdding: closingTime, to: today)
        else {
            return false
        }

        return now >= open && now <= close
    }
}

enum LocalRestaurantService {
    static let all: [LocalRestaurant] = [
        .init(
            id: "1",
            name: "Choolah",
            imageName: "choolah",
            cuisineType: "Indian",
            averageRating: 4.5,
            openingTime: .init(hour: 11, minute: 0),
            closingTime: .init(hour: 15, minute: 0)
        ),
        .init(
            id: "2",
            name: "D’Angelo’s",
            imageName: "dangelo",
            cuisineType: "American",
            averageRating: 4.2,
            openingTime: .init(hour: 13, minute: 0),
            closingTime: .init(hour: 21, minute: 0)
        ),
        .init(
            id: "3",
            name: "The Halal Shack",
            imageName: "halal_shack",
            cuisineType: "Middle Eastern",
            averageRating: 4.7,
            openingTime: .init(hour: 12, minute: 0),
            closingTime: .init(hour: 13, minute: 0)
        ),
        .init(
            id: "4",
            name: "Popeyes",
            imageName: "popeyes",
            cuisineType: "Fast Food",
            averageRating: 4.1,
            openingTime: .init(hour: 14, minute: 0),
            closingTime: .init(hour: 16, minute: 30)
        ),
        .init(
            id: "5",
            name: "Subway",
            imageName: "subway",
            cuisineType: "Sandwiches",
            averageRating: 4.0,
            openingTime: .init(hour: 17, minute: 0),
            closingTime: .init(hour: 23, minute: 0)
        )
    ]
}
