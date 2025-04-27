//
//  CartManager.swift
//  Campus Dining App
//
//  Created by Vikas Rao Meneni    on 17/4/25.
//


import Foundation
import SwiftUI

class CartManager: ObservableObject {
    @Published var items: [OrderItem] = []
    @Published var restaurant: Restaurant?
    
    func addItem(_ item: OrderItem, from restaurant: Restaurant) {
        // Check if we're adding from a different restaurant
        if let currentRestaurant = self.restaurant, currentRestaurant.id != restaurant.id {
            // Clear cart if adding from a different restaurant
            items.removeAll()
        }
        
        // Set the restaurant
        self.restaurant = restaurant
        
        // Check if the item already exists in the cart
        if let index = items.firstIndex(where: { $0.menuItemId == item.menuItemId && $0.specialInstructions == item.specialInstructions }) {
            // Update the quantity of the existing item
            items[index].quantity += item.quantity
        } else {
            // Add the new item
            items.append(item)
        }
    }
    
    func removeItem(at index: Int) {
        items.remove(at: index)
        
        if items.isEmpty {
            restaurant = nil
        }
    }
    
    func updateQuantity(for index: Int, quantity: Int) {
        guard index < items.count, quantity > 0 else { return }
        items[index].quantity = quantity
    }
    
    func clearCart() {
        items.removeAll()
        restaurant = nil
    }
    
    var totalAmount: Double {
        items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
    
    var isEmpty: Bool {
        items.isEmpty
    }
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
}