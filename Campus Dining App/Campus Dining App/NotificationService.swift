// NotificationService.swift

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    private init() {}

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current()
          .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async { completion(granted) }
            if let error = error {
                print("❌ Notification permission error:", error.localizedDescription)
            }
        }
    }

    /// Immediate (~1s) “Order Placed” alert
    func scheduleImmediateNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(req) { error in
            if let error = error {
                print("❌ Scheduling immediate notification:", error.localizedDescription)
            }
        }
    }

    /// “Order Ready” at the estimatedReadyTime
    func scheduleOrderReadyNotification(for order: Order) {
        let content = UNMutableNotificationContent()
        content.title = "Your Order is Ready!"
        content.body  = "Your order from \(order.restaurantName) is ready for pickup."
        content.sound = .default

        let interval = max(order.estimatedReadyTime.timeIntervalSinceNow, 0)
        let trigger  = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let req = UNNotificationRequest(
            identifier: "order-ready-\(order.id ?? UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(req) { error in
            if let error = error {
                print("❌ Scheduling ready notification:", error.localizedDescription)
            }
        }
    }

    func cancelNotifications(for orderId: String) {
        UNUserNotificationCenter.current()
          .removePendingNotificationRequests(withIdentifiers: ["order-ready-\(orderId)"])
    }
}
