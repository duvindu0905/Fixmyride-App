import SwiftUI

class GlobalDto: ObservableObject {
    static let shared = GlobalDto()

    @Published var isLoggedIn: Bool = false
    @Published var role: UserRole = .none
    @Published var commingFrom: String = ""
    @Published var paths: [String] = []
}

enum UserRole {
    case scholar
    case admin
    case none
}

