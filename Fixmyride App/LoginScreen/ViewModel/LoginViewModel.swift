import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var emailOrPhone: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    func login() {
        // Simulate authentication logic
        if emailOrPhone.isEmpty || password.isEmpty {
            errorMessage = "Please enter both email/phone and password."
            isAuthenticated = false
        } else {
            // TODO: Replace with actual authentication logic (API call, database, etc.)
            isAuthenticated = true
            errorMessage = nil
        }
    }
}

