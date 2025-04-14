import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String?

    func login() -> Bool {
        if email.isEmpty {
            errorMessage = "Please enter your email."
            return false
        }

        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Please enter a valid email address."
            return false
        }

        errorMessage = nil

        Task {
            await sendOtp()
        }

        return true
    }

    func sendOtp() async {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/send-otp") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email]
        request.httpBody = try? JSONEncoder().encode(body)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let res = response as? HTTPURLResponse, res.statusCode != 200 {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to send OTP"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Server error: \(error.localizedDescription)"
            }
        }
    }
}


