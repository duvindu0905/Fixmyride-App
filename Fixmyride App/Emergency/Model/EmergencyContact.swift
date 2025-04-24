import SwiftUI

struct EmergencyContact: Identifiable {
    let id = UUID()
    let title: String
    let phoneNumber: String
    let iconName: String
}

struct EmergencyContactDTO: Codable {
    let title: String
    let phoneNumber: String
}

