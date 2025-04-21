import SwiftUI
import MapKit

struct BreakdownType: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
}

struct Mechanic: Identifiable, Codable {
    var id: String { _id } 
    let _id: String
    let name: String
    let distance: Double
    let price: Double
    let contact: String
    let isAvailable: Bool
    let latitude: Double
    let longitude: Double
}


