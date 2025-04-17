import SwiftUI

enum GarageType: String, Codable {
    case repairCenter, engineering, detailing, painting
}

enum AvailabilityLevel: String, Codable {
    case low, moderate, high
}

struct GarageModel: Identifiable, Codable {
    var id = UUID()
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
}

struct MapModel {
    var mapId: Int
    var name: String
    var garages: [GarageModel]
}
