//
//  TermsView.swift
//  Campus Dining App
//
//  Created by Vikas Rao Meneni    on 25/4/25.
//


import SwiftUI

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Terms and Conditions")
                    .font(.title2)
                    .bold()

                Text("These terms govern your use of the Campus Dining App. Please read them carefully. By using this app, you agree to be bound by these terms.")
                
                Text("1. You must be a registered user to place orders.")
                Text("2. All prices and availability are subject to change without notice.")
                Text("3. Orders may be canceled if the restaurant is unavailable.")
                Text("4. We are not responsible for delays in delivery.")
            }
            .padding()
        }
        .navigationTitle("Terms & Conditions")
        .navigationBarTitleDisplayMode(.inline)
    }
}
