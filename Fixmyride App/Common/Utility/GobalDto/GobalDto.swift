import SwiftUI

class GlobalDto: ObservableObject {
    static let shared = GlobalDto()

    // Whether the user is logged in
    @Published var isLoggedIn: Bool = false

    // Logged-in user's email
    @Published var email: String = ""

    // Where the user came from (e.g., "registration", "forgotPassword")
    @Published var comingFrom: String = ""

    // Navigation stack path used in NavigationStack
    @Published var paths: [String] = []
}

