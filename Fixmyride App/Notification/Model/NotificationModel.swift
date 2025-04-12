import Foundation

struct NotificationModel: Identifiable, Codable {
    var id: String
    var title: String
    var message: String
    var day: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case message
        case day = "date"
    }
}

