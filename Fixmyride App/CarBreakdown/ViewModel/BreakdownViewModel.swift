import SwiftUI
import MapKit

class BreakdownViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = BreakdownViewModel()

    @Published var selectedType: BreakdownType?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var selectedMechanic: Mechanic?
    @Published var availableMechanics: [Mechanic] = []
    @Published var selectedDate = Date()

    private let locationManager = CLLocationManager()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first?.coordinate
    }

    func fetchNearbyMechanics() {
        guard let userLoc = userLocation else { return }

        availableMechanics = [
            Mechanic(name: "Turbo Station", distance: 2, price: 12000, location: userLoc, contact: "+94771234567", isAvailable: true),
            Mechanic(name: "R.S. Motors", distance: 5, price: 15000, location: userLoc, contact: "+94775678901", isAvailable: true),
            Mechanic(name: "Manuja Garage", distance: 7, price: 18000, location: userLoc, contact: "+94779998888", isAvailable: false),
        ]
    }
}


