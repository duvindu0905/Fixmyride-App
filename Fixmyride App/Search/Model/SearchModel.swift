import SwiftUI
import Foundation

enum GarageType: String, Codable {
    case repairCenter, engineering, detailing, painting
}

enum AvailabilityLevel: String, Codable {
    case low, moderate, high
}

struct GarageModel: Identifiable, Codable {
    var id: String // This will map from _id
    var garageId: Int
    var name: String
    var type: GarageType
    var mobile: String
    var latitude: Double
    var longitude: Double
    var address: String
    var imageUrls: [String]?
    var availabilityInDouble: Double
    var availabilityInString: AvailabilityLevel

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case garageId
        case name
        case type
        case mobile
        case latitude
        case longitude
        case address
        case imageUrls
        case availabilityInDouble
        case availabilityInString
    }
}

