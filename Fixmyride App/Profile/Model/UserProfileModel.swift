import SwiftUI

struct UserProfileModel: Identifiable, Codable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: Int
    var memberSince: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case email
        case phoneNumber
        case memberSince
    }
}

