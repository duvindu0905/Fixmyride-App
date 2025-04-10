import SwiftUI

class ProfileViewModel {
    static let shared = ProfileViewModel()

    private init() {}

    func getUserProfile() -> UserProfileModel {
        //network call
        return UserProfileModel(
            firstName: "Duvindu",
            lastName: "Thimbiri",
            email: "duvindu@gmail.com",
            phoneNumber: 0776632994,
            memberSince: "20th of April 2025",
        )
    }
}
