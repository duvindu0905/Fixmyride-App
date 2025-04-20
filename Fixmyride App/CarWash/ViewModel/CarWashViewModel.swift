import SwiftUI
import MapKit

final class CarWashViewModel: ObservableObject {
    static let shared = CarWashViewModel()
    private init() {}

    @Published var currentStep: Int = 0
    @Published var selectedWashType: WashType?
    @Published var selectedDate: Date = Date()
    @Published var selectedTimeSlot: String = ""
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var selectedStation: WashStation?
    @Published var availableStations: [WashStation] = []

   
    let washTypes: [WashType] = [
        WashType(title: "Basic Wash",           iconName: "drop.fill"),
        WashType(title: "Deluxe Wash",          iconName: "sparkles"),
        WashType(title: "Interior Detailing",   iconName: "car.fill"),
        WashType(title: "Exterior Polish",      iconName: "wand.and.stars")
    ]

    func fetchNearbyStations() {
        guard userLocation != nil else { return }

        availableStations = [
            WashStation(name: "Crystal Clean Car Wash", distance: 3.5,
                        price: 2500, isAvailable: true,  contact: "+94 71 234 5678"),
            WashStation(name: "Speedy Wash Center",     distance: 5.0,
                        price: 3000, isAvailable: true,  contact: "+94 77 456 7890"),
            WashStation(name: "AutoGleam Wash Bay",     distance: 6.2,
                        price: 3500, isAvailable: false, contact: "+94 76 123 4567")
        ]
    }

    func getAvailableTimeSlots() -> [TimeSlot] {
        [
            TimeSlot(label: "8:00 – 8:30 am",  isAvailable: true),
            TimeSlot(label: "8:30 – 9:00 am",  isAvailable: false),
            TimeSlot(label: "9:00 – 9:30 am",  isAvailable: true),
            TimeSlot(label: "9:30 – 10:00 am", isAvailable: true),
            TimeSlot(label: "10:00 – 10:30 am",isAvailable: false),
            TimeSlot(label: "10:30 – 11:00 am",isAvailable: true),
            TimeSlot(label: "11:00 – 11:30 am",isAvailable: true),
            TimeSlot(label: "11:30 – 12:00 pm",isAvailable: false)
        ]
    }
}

