//
//  NotificationBannerView.swift
//  Campus Dining App
//
//  Created by Vikas Rao Meneni    on 17/4/25.
//


import SwiftUI

struct NotificationBannerView: View {
    let notification: AppNotification
    @ObservedObject var notificationManager = NotificationManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notification.title)
              .font(.headline)
              .foregroundColor(.white)
            Text(notification.message)
              .font(.subheadline)
              .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .cornerRadius(8)
        .shadow(radius: 3)
        .padding(.horizontal)
        .onTapGesture {
            notificationManager.removeNotification(id: notification.id)
        }
    }

    private var backgroundColor: Color {
        switch notification.type {
        case .order: return .green
        case .info:  return .blue
        case .error: return .red
        }
    }
}
