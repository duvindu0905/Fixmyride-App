import SwiftUI
import MapKit

struct BreakdownType: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
}

struct Mechanic: Identifiable {
    let id = UUID()
    let name: String
    let distance: Double
    let price: Double
    let location: CLLocationCoordinate2D
    let contact: String
    let isAvailable: Bool
}

