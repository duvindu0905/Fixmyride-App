import Foundation

class ProfileViewModel: ObservableObject {
    static let shared = ProfileViewModel()

    @Published var userProfile: UserProfileModel?

    private init() {}

    func fetchUserProfile(byEmail email: String) {
        guard let url = URL(string: "https://yourapi.com/api/profile?email=\(email)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching profile:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let profile = try JSONDecoder().decode(UserProfileModel.self, from: data)
                DispatchQueue.main.async {
                    self.userProfile = profile
                }
            } catch {
                print("Decoding error:", error.localizedDescription)
            }
        }.resume()
    }

    func updateUserProfile(_ updatedProfile: UserProfileModel, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://yourapi.com/api/profile") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(updatedProfile)
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error updating profile:", error!.localizedDescription)
                    completion(false)
                    return
                }
                completion(true)
            }.resume()

        } catch {
            print("Encoding error:", error.localizedDescription)
            completion(false)
        }
    }
}
