import SwiftUI

class GlobalDto: ObservableObject {
    static let shared = GlobalDto()

    // user is logged in
    @Published var isLoggedIn: Bool = false

    // Logged-in user's email
    @Published var email: String = ""

    // Where the user came from
    @Published var comingFrom: String = ""

    // Navigation stack 
    @Published var paths: [String] = []
}

