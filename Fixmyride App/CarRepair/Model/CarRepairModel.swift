import SwiftUI
import MapKit

struct RepairType: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
}

struct TimeSlot: Identifiable {
    let id = UUID()
    let label: String
    let isAvailable: Bool
}

struct RepairStation: Identifiable {
    let id = UUID()
    let name: String
    let distance: Double
    let price: Double
    let isAvailable: Bool
    let contact: String
}
