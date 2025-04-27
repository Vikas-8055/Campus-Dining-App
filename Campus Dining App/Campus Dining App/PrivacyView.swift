//
//  PrivacyView.swift
//  Campus Dining App
//
//  Created by Vikas Rao Meneni    on 25/4/25.
//


import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Privacy Policy")
                    .font(.title2)
                    .bold()

                Text("We value your privacy. This policy describes how we collect, use, and share your information.")
                
                Text("• We only collect necessary information to operate the app.")
                Text("• We do not sell your data.")
                Text("• Your information is protected and securely stored.")
                Text("• You can request deletion of your data anytime.")
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}
