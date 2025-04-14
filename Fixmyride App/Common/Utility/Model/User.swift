import Foundation

struct User: Identifiable, Codable {
    var id: UUID = UUID()
    var email: String
}

