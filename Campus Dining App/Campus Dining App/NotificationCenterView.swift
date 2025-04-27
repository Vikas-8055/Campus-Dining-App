import SwiftUI

struct NotificationCenterView: View {
    @ObservedObject var notificationManager = NotificationManager.shared

    var body: some View {
        VStack(spacing: 8) {
            ForEach(notificationManager.notifications) { note in
                NotificationBannerView(notification: note)
                  .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: notificationManager.notifications.map { $0.id })
    }
}
