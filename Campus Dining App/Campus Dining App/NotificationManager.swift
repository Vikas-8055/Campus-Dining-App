//
//  NotificationManager.swift
//  Campus Dining App
//
//  Created by Vikas Rao Meneni    on 17/4/25.
//


import SwiftUI
import Foundation

class NotificationManager: ObservableObject {
    @Published var notifications: [AppNotification] = []
    
    // Singleton instance
    static let shared = NotificationManager()
    
    private init() {}
    
    func addNotification(title: String, message: String, type: NotificationType) {
        let notification = AppNotification(id: UUID(), title: title, message: message, type: type, timestamp: Date())
        
        DispatchQueue.main.async {
            self.notifications.append(notification)
            
            // Automatically remove after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.removeNotification(id: notification.id)
            }
        }
    }
    
    func removeNotification(id: UUID) {
        DispatchQueue.main.async {
            self.notifications.removeAll { $0.id == id }
        }
    }
    
    func clearAllNotifications() {
        DispatchQueue.main.async {
            self.notifications.removeAll()
        }
    }
}

struct AppNotification: Identifiable {
    let id: UUID
    let title: String
    let message: String
    let type: NotificationType
    let timestamp: Date
}

enum NotificationType {
    case order
    case info
    case error
}