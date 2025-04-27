//
//  Models.swift   (Restaurant, MenuItem, UserProfile, OrderItem, Order)
//  Campus Dining App
//

import Foundation
import FirebaseFirestore


// MARK: - Restaurant ---------------------------------------------------------

struct Restaurant: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var imageURL: String
    var location: String
    var hours: String          // ← unified key
    var cuisineType: String
    var averageRating: Double

    init(id: String? = nil,
         name: String,
         description: String,
         imageURL: String,
         location: String,
         hours: String,
         cuisineType: String,
         averageRating: Double) {

        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.location = location
        self.hours = hours
        self.cuisineType = cuisineType
        self.averageRating = averageRating
    }

    // Snapshot → Model
    static func fromFirestore(document: DocumentSnapshot) -> Restaurant? {
        guard let data = document.data(),
              let name = data["name"] as? String,
              let description = data["description"] as? String,
              let imageURL = data["imageURL"] as? String,
              let location = data["location"] as? String,
              let hours = data["hours"] as? String,          // ← match field
              let cuisineType = data["cuisineType"] as? String,
              let averageRating = data["averageRating"] as? Double
        else { return nil }

        return Restaurant(id: document.documentID,
                          name: name,
                          description: description,
                          imageURL: imageURL,
                          location: location,
                          hours: hours,
                          cuisineType: cuisineType,
                          averageRating: averageRating)
    }

    // Model → Firestore
    func toFirestore() -> [String: Any] {
        [
            "name": name,
            "description": description,
            "imageURL": imageURL,
            "location": location,
            "hours": hours,                   // ← match field
            "cuisineType": cuisineType,
            "averageRating": averageRating
        ]
    }
}

// MARK: - MenuItem -----------------------------------------------------------

struct MenuItem: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var price: Double
    var imageURL: String
    var restaurantId: String
    var category: String
    var isAvailable: Bool
    var dietaryInfo: [String]
    var preparationTime: Int

    // Snapshot → Model
    static func fromFirestore(document: DocumentSnapshot) -> MenuItem? {
        guard let data = document.data(),
              let name = data["name"] as? String,
              let description = data["description"] as? String,
              let price = data["price"] as? Double,
              let imageURL = data["imageURL"] as? String,
              let restaurantId = data["restaurantId"] as? String,
              let category = data["category"] as? String,
              let isAvailable = data["isAvailable"] as? Bool,
              let dietaryInfo = data["dietaryInfo"] as? [String],
              let preparationTime = data["preparationTime"] as? Int
        else { return nil }

        return MenuItem(id: document.documentID,
                        name: name,
                        description: description,
                        price: price,
                        imageURL: imageURL,
                        restaurantId: restaurantId,
                        category: category,
                        isAvailable: isAvailable,
                        dietaryInfo: dietaryInfo,
                        preparationTime: preparationTime)
    }

    func toFirestore() -> [String: Any] {
        [
            "name": name,
            "description": description,
            "price": price,
            "imageURL": imageURL,
            "restaurantId": restaurantId,
            "category": category,
            "isAvailable": isAvailable,
            "dietaryInfo": dietaryInfo,
            "preparationTime": preparationTime
        ]
    }
}

// MARK: - UserProfile --------------------------------------------------------

struct UserProfile: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var dietaryPreferences: [String]
    var favoriteItems: [String]
    var fcmToken: String?

    static func fromFirestore(document: DocumentSnapshot) -> UserProfile? {
        guard let data = document.data(),
              let name = data["name"] as? String,
              let email = data["email"] as? String,
              let dietaryPreferences = data["dietaryPreferences"] as? [String],
              let favoriteItems = data["favoriteItems"] as? [String]
        else { return nil }

        return UserProfile(id: document.documentID,
                           name: name,
                           email: email,
                           dietaryPreferences: dietaryPreferences,
                           favoriteItems: favoriteItems,
                           fcmToken: data["fcmToken"] as? String)
    }

    func toFirestore() -> [String: Any] {
        var dict: [String: Any] = [
            "name": name,
            "email": email,
            "dietaryPreferences": dietaryPreferences,
            "favoriteItems": favoriteItems
        ]
        if let token = fcmToken { dict["fcmToken"] = token }
        return dict
    }
}

// MARK: - OrderItem ----------------------------------------------------------

struct OrderItem: Identifiable, Codable {
    var id = UUID().uuidString
    var menuItemId: String
    var name: String
    var price: Double
    var quantity: Int
    var specialInstructions: String?

    func toFirestore() -> [String: Any] {
        [
            "id": id,
            "menuItemId": menuItemId,
            "name": name,
            "price": price,
            "quantity": quantity,
            "specialInstructions": specialInstructions as Any
        ]
    }

    static func fromFirestore(data: [String: Any]) -> OrderItem? {
        guard let id = data["id"] as? String,
              let menuItemId = data["menuItemId"] as? String,
              let name = data["name"] as? String,
              let price = data["price"] as? Double,
              let quantity = data["quantity"] as? Int
        else { return nil }

        return OrderItem(id: id,
                         menuItemId: menuItemId,
                         name: name,
                         price: price,
                         quantity: quantity,
                         specialInstructions: data["specialInstructions"] as? String)
    }
}

// MARK: - Order --------------------------------------------------------------

enum OrderStatus: String, Codable { case pending, preparing, ready, completed, cancelled }

struct Order: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var restaurantId: String
    var restaurantName: String
    var items: [OrderItem]
    var totalAmount: Double
    var status: OrderStatus
    var placedTime: Date
    var estimatedReadyTime: Date
    var paymentMethod: String
    var paymentComplete: Bool

    var formattedPlacedTime: String {
        DateFormatter.localizedString(from: placedTime, dateStyle: .short, timeStyle: .short)
    }
    var formattedEstimatedReadyTime: String {
        DateFormatter.localizedString(from: estimatedReadyTime, dateStyle: .none, timeStyle: .short)
    }

    static func fromFirestore(document: DocumentSnapshot) -> Order? {
        guard let data = document.data(),
              let userId = data["userId"] as? String,
              let restaurantId = data["restaurantId"] as? String,
              let restaurantName = data["restaurantName"] as? String,
              let itemsData = data["items"] as? [[String: Any]],
              let totalAmount = data["totalAmount"] as? Double,
              let statusString = data["status"] as? String,
              let status = OrderStatus(rawValue: statusString),
              let placedTS = data["placedTime"] as? Timestamp,
              let readyTS = data["estimatedReadyTime"] as? Timestamp,
              let paymentMethod = data["paymentMethod"] as? String,
              let paymentComplete = data["paymentComplete"] as? Bool
        else { return nil }

        let items = itemsData.compactMap(OrderItem.fromFirestore)

        return Order(id: document.documentID,
                     userId: userId,
                     restaurantId: restaurantId,
                     restaurantName: restaurantName,
                     items: items,
                     totalAmount: totalAmount,
                     status: status,
                     placedTime: placedTS.dateValue(),
                     estimatedReadyTime: readyTS.dateValue(),
                     paymentMethod: paymentMethod,
                     paymentComplete: paymentComplete)
    }

    func toFirestore() -> [String: Any] {
        [
            "userId": userId,
            "restaurantId": restaurantId,
            "restaurantName": restaurantName,
            "items": items.map { $0.toFirestore() },
            "totalAmount": totalAmount,
            "status": status.rawValue,
            "placedTime": Timestamp(date: placedTime),
            "estimatedReadyTime": Timestamp(date: estimatedReadyTime),
            "paymentMethod": paymentMethod,
            "paymentComplete": paymentComplete
        ]
    }
}
