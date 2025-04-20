import SwiftUI
import MapKit

class CarRepairViewModel: ObservableObject {
    static let shared = CarRepairViewModel()

    @Published var currentStep: Int = 0
    @Published var selectedRepairType: RepairType?
    @Published var selectedDate: Date = Date()
    @Published var selectedTimeSlot: String = ""
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var selectedStation: RepairStation?

    @Published var availableStations: [RepairStation] = []

    let repairTypes: [RepairType] = [
        RepairType(title: "Full Repair", iconName: "wrench.and.screwdriver.fill"),
        RepairType(title: "Battery Replacement", iconName: "bolt.batteryblock.fill"),
        RepairType(title: "AC Repair", iconName: "fanblades.fill"),
        RepairType(title: "Brake Washer Change", iconName: "drop.fill"),
        RepairType(title: "Engine Oil Change", iconName: "gearshape.fill"),
        RepairType(title: "Replace Brake Pad", iconName: "car.side.fill")
    ]

    private init() {}

    func fetchNearbyStations() {
        guard let _ = userLocation else { return }

        self.availableStations = [
            RepairStation(name: "Turbo Station", distance: 2, price: 12000, isAvailable: true, contact: "+94 77 123 4567"),
            RepairStation(name: "R.S. Motors", distance: 5, price: 15000, isAvailable: true, contact: "+94 77 987 6543"),
            RepairStation(name: "Manuja Garage", distance: 7, price: 18000, isAvailable: false, contact: "+94 71 555 1234")
        ]
    }

    func getAvailableTimeSlots() -> [TimeSlot] {
        return [
            TimeSlot(label: "8:00 - 8:30am", isAvailable: true),
            TimeSlot(label: "8:30 - 9:00am", isAvailable: false),
            TimeSlot(label: "9:00 - 9:30am", isAvailable: true),
            TimeSlot(label: "9:30 - 10:00am", isAvailable: true),
            TimeSlot(label: "10:00 - 10:30am", isAvailable: false),
            TimeSlot(label: "10:30 - 11:00am", isAvailable: true),
            TimeSlot(label: "11:00 - 11:30am", isAvailable: true),
            TimeSlot(label: "11:30 - 12:00pm", isAvailable: false)
        ]
    }
}

