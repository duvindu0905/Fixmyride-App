import SwiftUI

struct UserProfileModel: Identifiable, Codable {
    var id: UUID = UUID()
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: Int
    var memberSince: String
}
