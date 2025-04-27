//
//  EditProfileView.swift
//  Campus Dining App
//
//  Created by Vikas Rao Meneni on 17/4/25.
//

import SwiftUI

struct EditProfileView: View {
    // Always inject exactly like this — no “= …”
    @EnvironmentObject private var dataManager: DataManager
    @Environment(\.dismiss)    private var dismiss

    @State private var profile: UserProfile
    @State private var name:    String
    @State private var email:   String

    init(profile: UserProfile) {
        self._profile = State(initialValue: profile)
        self._name    = State(initialValue: profile.name)
        self._email   = State(initialValue: profile.email)
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Profile Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .disabled(true)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveProfile() }
                }
            }
        }
    }

    private func saveProfile() {
        var updated = profile
        updated.name = name

        dataManager.updateUserProfile(profile: updated) { success in
            if success {
                dismiss()
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a dummy profile instance here
        let dummy = UserProfile(
            id: "u1",
            name: "Test Student",
            email: "test@student.edu",
            dietaryPreferences: ["Vegan", "Gluten‑Free"],
            favoriteItems: ["m1", "m2"]
        )

        return EditProfileView(profile: dummy)
            .environmentObject(DataManager.shared)
    }
}
