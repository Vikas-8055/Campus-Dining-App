//  ProfileView.swift
//  Campus Dining App

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var dataManager: DataManager
    @State private var showingEditProfile = false
    @State private var showingDietaryPreferences = false
    @State private var showingSignOut = false

    var body: some View {
        NavigationView {
            List {
                if dataManager.isAuthenticated,
                   let profile = dataManager.userProfile {

                    // MARK: - User Info
                    Section {
                        HStack(spacing: 16) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(profile.name)
                                    .font(.title3).fontWeight(.bold)
                                Text(profile.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }

                    // MARK: - Preferences
                    Section("Preferences") {
                        Button {
                            showingEditProfile = true
                        } label: {
                            Label("Edit Profile", systemImage: "person.fill")
                        }

                        Button {
                            showingDietaryPreferences = true
                        } label: {
                            Label("Dietary Preferences", systemImage: "leaf.fill")
                        }
                    }

                    // MARK: - Account
                    Section("Account") {
                        Button(role: .destructive) {
                            showingSignOut = true
                        } label: {
                            Label("Sign Out", systemImage: "arrow.right.square")
                        }
                    }

                } else {
                    Section {
                        NavigationLink(destination: AuthView()) {
                            Text("Sign In")
                        }
                    }
                }

                // MARK: - About
                Section("About") {
                    NavigationLink(destination: TermsView()) {
                        Label("Terms and Conditions", systemImage: "doc.text")
                    }
                    NavigationLink(destination: PrivacyView()) {
                        Label("Privacy Policy", systemImage: "lock.shield")
                    }
                    NavigationLink(destination: AppVersionView()) {
                        Label("App Version", systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("Profile")

            // Edit Profile Sheet
            .sheet(isPresented: $showingEditProfile) {
                if let profile = dataManager.userProfile {
                    EditProfileView(profile: profile)
                        .environmentObject(dataManager)
                }
            }

            // Dietary Preferences Sheet
            .sheet(isPresented: $showingDietaryPreferences) {
                DietaryPreferencesView()
            }

            // Sign Out Confirmation
            .alert("Sign Out", isPresented: $showingSignOut) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    dataManager.signOut { _ in }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(DataManager.shared)
    }
}
