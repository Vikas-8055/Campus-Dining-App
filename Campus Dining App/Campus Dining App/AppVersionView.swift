//
//  AppVersionView.swift
//  Campus Dining App
//
//  Created by Vikas Rao Meneni    on 25/4/25.
//


import SwiftUI

struct AppVersionView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "app.gift.fill")
                .font(.system(size: 48))
                .foregroundColor(.blue)

            Text("Campus Dining App")
                .font(.title2)
                .bold()

            Text("Version 1.0.0")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("App Version")
        .navigationBarTitleDisplayMode(.inline)
    }
}
