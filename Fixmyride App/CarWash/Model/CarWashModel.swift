import SwiftUI
import MapKit

struct WashType: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
}


struct WashStation: Identifiable {
    let id = UUID()
    let name: String
    let distance: Double
    let price: Double          
    let isAvailable: Bool
    let contact: String
}

