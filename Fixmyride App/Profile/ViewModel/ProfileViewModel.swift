import SwiftUI

class ProfileViewModel: ObservableObject {
    static let shared = ProfileViewModel()

    @Published var userProfile: UserProfileModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private init() {}

    func fetchUserProfile(byEmail email: String) {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/profile?email=duvindudushan7.info@gmail.com") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async { self.isLoading = false }

            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                }
                return
            }

            do {
                let profile = try JSONDecoder().decode(UserProfileModel.self, from: data)
                DispatchQueue.main.async {
                    self.userProfile = profile
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode profile"
                }
            }
        }.resume()
    }

    func updateUserProfile(_ updatedProfile: UserProfileModel, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/profile") else {
            errorMessage = "Invalid URL"
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": updatedProfile.email,
            "firstName": updatedProfile.firstName,
            "lastName": updatedProfile.lastName,
            "phoneNumber": updatedProfile.phoneNumber
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to encode request body"
            }
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Update failed: \(error!.localizedDescription)"
                }
                completion(false)
                return
            }

            DispatchQueue.main.async {
                completion(true)
            }
        }.resume()
    }
}
