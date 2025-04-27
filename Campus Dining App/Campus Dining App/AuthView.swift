import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isSignUp = false

    @State private var showAlert = false
    @State private var alertMsg = ""

    var body: some View {
        VStack(spacing: 24) {

            Image(systemName: "fork.knife")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Campus Dining")
                .font(.largeTitle).bold()

            Text(isSignUp ? "Create an Account" : "Welcome Back")
                .font(.title2)

            Spacer().frame(height: 32)

            formFields

            primaryButton
                .padding(.horizontal)

            toggleModeButton

            Spacer()
        }
        .padding()
        .alert(alertMsg, isPresented: $showAlert) { Button("OK", role: .cancel) { } }
        .onChange(of: dataManager.isAuthenticated) { if $0 { dismiss() } }
    }

    // MARK: – Sub-views
    private var formFields: some View {
        VStack(spacing: 16) {
            if isSignUp {
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.words)
            }
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.horizontal)
    }

    private var primaryButton: some View {
        Button(isSignUp ? "Sign Up" : "Sign In") {
            authenticate()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    private var toggleModeButton: some View {
        Button(isSignUp ?
               "Already have an account? Sign In"
             : "Don't have an account? Sign Up") {
            isSignUp.toggle()
            email = ""; password = ""; name = ""
        }
        .foregroundColor(.blue)
    }

    // MARK: – Logic
    private func authenticate() {
        if isSignUp {
            guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
                showAlert("Please fill all fields"); return
            }
            
            // Add validation checks
            guard isValidName(name) else {
                showAlert("Name must be at least 5 characters long"); return
            }
            
            guard isValidPassword(password) else {
                showAlert("Password must contain at least 5 characters, one capital letter, and one special character"); return
            }
            
            guard isNortheasternEmail(email) else {
                showAlert("Please use a valid Northeastern email address (example@northeastern.edu)"); return
            }
            
            dataManager.signUp(email: email, password: password, name: name) { ok in
                if ok {
                    self.showAlert("Account created! Please sign in.")
                    self.isSignUp = false
                    self.password = ""
                } else {
                    self.showAlert("Sign-up failed. Try again.")
                }
            }
        } else {
            guard !email.isEmpty, !password.isEmpty else {
                showAlert("Enter e-mail and password"); return
            }
            
            // For login, we also check email format
            guard isNortheasternEmail(email) else {
                showAlert("Please use a valid Northeastern email address (example@northeastern.edu)"); return
            }
            
            // For login, we also check password requirements
            guard isValidPassword(password) else {
                showAlert("Password must contain at least 5 characters, one capital letter, and one special character"); return
            }
            
            dataManager.signIn(email: email, password: password) { ok in
                if !ok { self.showAlert("Invalid credentials") }
            }
        }
    }
    
    // Validation functions
    private func isValidName(_ name: String) -> Bool {
        return name.count >= 5
    }

    private func isValidPassword(_ password: String) -> Bool {
        // Check minimum length of 5 characters
        guard password.count >= 5 else { return false }
        
        // Check for at least one capital letter
        let capitalLetterRegex = ".*[A-Z]+.*"
        let capitalLetterPredicate = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegex)
        let hasCapital = capitalLetterPredicate.evaluate(with: password)
        
        // Check for at least one special character
        let specialCharRegex = ".*[!&^%$#@()/]+.*"
        let specialCharPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharRegex)
        let hasSpecialChar = specialCharPredicate.evaluate(with: password)
        
        return hasCapital && hasSpecialChar
    }

    private func isNortheasternEmail(_ email: String) -> Bool {
        // Check specifically for northeastern.edu domain
        return email.lowercased().hasSuffix("@northeastern.edu")
    }

    // Alert helper
    private func showAlert(_ msg: String) {
        alertMsg = msg
        showAlert = true
    }
}
