import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String?

    func login() -> Bool {
        if email.isEmpty {
            errorMessage = "Please enter your email."
            return false
        }

        // ✅ You can add simple validation if needed:
        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Please enter a valid email address."
            return false
        }

        errorMessage = nil
        return true
    }
}

