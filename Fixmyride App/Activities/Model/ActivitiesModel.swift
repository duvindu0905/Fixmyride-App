import SwiftUI

struct ActivityModel: Identifiable, Codable {
    var id: String
    var bookingId: String
    var centerName: String
    var description: String
    var date: String
    var price: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case bookingId
        case centerName
        case description
        case date
        case price
    }
}

