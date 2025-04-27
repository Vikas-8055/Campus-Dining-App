import SwiftUI

struct DietaryPreferencesView: View {
    @Environment(\.dismiss) var dismiss

    @AppStorage("dietaryPreferences") private var savedPreferences = ""
    @State private var preferences: Set<String> = []

    let allDietaryOptions = [
        "Vegetarian","Vegan","Gluten-Free","Dairy-Free",
        "Nut-Free","Halal","Kosher","Low-Carb","Keto","Pescatarian"
    ]

    var body: some View {
        NavigationView {
            List {
                Section("Select Your Dietary Preferences") {
                    ForEach(allDietaryOptions, id: \.self) { option in
                        Button {
                            if preferences.contains(option) {
                                preferences.remove(option)
                            } else {
                                preferences.insert(option)
                            }
                        } label: {
                            HStack {
                                Text(option)
                                Spacer()
                                if preferences.contains(option) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dietary Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savedPreferences = preferences.joined(separator: ",")
                        dismiss()
                    }
                }
            }
            .onAppear {
                let saved = savedPreferences.split(separator: ",").map { String($0) }
                preferences = Set(saved)
            }
        }
    }
}
